
namespace Incubakery
{
    using UnityEngine;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using LibNoise;
    using LibNoise.Generator;
    using LibNoise.Operator;

    public class World
    {
        private readonly WorldFactory worldFactory;

        private Chunk[,,] chunks;

        private ConcurrentBag<ChunkPosition> renderQueue = new ConcurrentBag<ChunkPosition>();

        public bool IsLoading { get; set; }

        public ModuleBase Generator { get; private set; }

        public World(WorldFactory worldFactory, ModuleBase generator)
        {
            this.worldFactory = worldFactory;
            this.Generator = generator;
        }

        public void Initialize()
        {
            this.chunks = new Chunk[
                Constants.Context.MaxChunksInXDimension,
                Constants.Context.MaxChunksInYDimension,
                Constants.Context.MaxChunksInZDimension];

            for (int x = 0; x < Constants.Context.MaxChunksInXDimension; ++x)
            {
                for (int y = 0; y < Constants.Context.MaxChunksInYDimension; ++y)
                {
                    for (int z = 0; z < Constants.Context.MaxChunksInZDimension; ++z)
                    {
                        this.chunks[x, y, z] = this.CreateChunk(new ChunkPosition(x, y, z));
                    }
                }
            }

            WorldContext.Instance.EnqueueMessage(new GenerateWorldMessage(this));
        }

        public Chunk[,,] GetChunksCopy()
        {
            return (Chunk[,,])chunks.Clone();
        }

        public void Tick_UnityThread()
        {
            ChunkPosition chunkPosition;
            while (this.renderQueue.TryTake(out chunkPosition))
            {
                this.chunks[chunkPosition.X, chunkPosition.Y, chunkPosition.Z]
                    .RenderMeshIfRequired_UnityThread(this.worldFactory);
            }
        }

        public void AddToRenderQueue(ChunkPosition chunkPosition)
        {
            this.renderQueue.Add(chunkPosition);
        }

        public IEnumerable<Chunk> GetAllChunks()
        {
            return this.chunks.Cast<Chunk>().ToList();
        }

        public Chunk TryGetChunk(ChunkPosition chunkPosition)
        {
            if (!chunkPosition.InRange)
            {
                return null;
            }

            return this.chunks[chunkPosition.X, chunkPosition.Y, chunkPosition.Z];
        }

        public BlockInstance GetBlockOrDefault(WorldPosition worldPosition)
        {
            var chunkPosition = worldPosition.ToChunkPosition();
            var chunk = this.TryGetChunk(chunkPosition);
            if (chunk == null)
            {
                if (worldPosition.IsWorldContainer())
                {
                    return BlockInstance.WorldContainer;
                }

                return BlockInstance.Air;
            }

            var blockPosition = worldPosition.ToBlockPosition();
            return chunk.GetBlockOrDefault(blockPosition);
        }

        public bool IsChunkSideOpaqueOrHidden(ChunkPosition chunkPosition, Direction direction)
        {
            var chunk = this.TryGetChunk(chunkPosition);
            if (chunk == null)
            {
                if (chunkPosition.IsWorldContainer())
                {
                    return true;
                }

                return false;
            }

            return chunk.IsSideOpaqueOrHidden(direction);
        }

        public bool IsChunkLoaded(ChunkPosition chunkPosition)
        {
            var chunk = this.TryGetChunk(chunkPosition);
            if (chunk == null)
            {
                return true;
            }

            return chunk.IsGenerated;
        }

        public bool TrySetBlock(WorldPosition worldPosition, BlockInstance blockInstance)
        {
            var chunkPosition = worldPosition.ToChunkPosition();
            Chunk chunk = this.TryGetChunk(chunkPosition);

            if (chunk == null)
            {
                return false;
            }

            var blockPosition = worldPosition.ToBlockPosition();
            chunk.TrySetBlock(blockPosition, blockInstance);
            chunk.UpdateMesh();

            if (blockPosition.X == 0)
            {
                this.UpdateChunkMesh(chunkPosition.PreviousX());
            }
            if (blockPosition.X == Constants.Context.ChunkDimensionLength - 1)
            {
                this.UpdateChunkMesh(chunkPosition.NextX());
            }

            if (blockPosition.Y == 0)
            {
                this.UpdateChunkMesh(chunkPosition.PreviousY());
            }
            if (blockPosition.Y == Constants.Context.ChunkDimensionLength - 1)
            {
                this.UpdateChunkMesh(chunkPosition.NextY());
            }

            if (blockPosition.Z == 0)
            {
                this.UpdateChunkMesh(chunkPosition.PreviousZ());
            }
            if (blockPosition.Z == Constants.Context.ChunkDimensionLength - 1)
            {
                this.UpdateChunkMesh(chunkPosition.NextZ());
            }

            return true;
        }

        private void UpdateChunkMesh(ChunkPosition chunkPosition)
        {
            Chunk chunk = this.TryGetChunk(chunkPosition);
            if (chunk != null)
            {
                chunk.UpdateMesh();
            }
        }

        private Chunk CreateChunk(ChunkPosition chunkPosition)
        {
            return new Chunk(this, chunkPosition);
        }
    }

}