using System.Collections.Generic;
using Aurayu.VoxelWorld.Voxel.Block;
using JetBrains.Annotations;
using UnityEngine;

namespace Aurayu.VoxelWorld.Voxel
{
    public class World
    {
        public Dictionary<Point3D, Chunk> Chunks;

        public World()
        {
            Chunks = new Dictionary<Point3D, Chunk>();
        }

        [CanBeNull]
        public Chunk GetChunk(Point3D chunkPositionInWorld)
        {
            Chunk chunk;
            Chunks.TryGetValue(chunkPositionInWorld, out chunk); 
            return chunk;
        }

        public IBlock GetBlock(Point3D worldPosition)
        {
            var chunkPositionInWorld = GetChunkPositionInWorld(worldPosition);
            var chunk = GetChunk(chunkPositionInWorld);

            if (chunk == null)
                return new AirBlock();

            var blockPositionInChunk = GetBlockPositionInChunk(worldPosition, chunk.Position);
            var block = chunk.GetBlock(blockPositionInChunk);

            return block;
        }

        public bool SetBlock(Point3D worldPosition, IBlock block, bool updateAdjacentChunks = false)
        {
            var chunkPositionInWorld = GetChunkPositionInWorld(worldPosition);
            var chunk = GetChunk(chunkPositionInWorld);

            if (chunk == null)
                return false;

            var x = worldPosition.X - chunk.Position.X;
            var y = worldPosition.Y - chunk.Position.Y;
            var z = worldPosition.Z - chunk.Position.Z;
            var updatedBlockPositionInChunk = new Point3D(x, y, z);
            var didSetBlock = chunk.SetBlock(updatedBlockPositionInChunk, block);

            if (didSetBlock && updateAdjacentChunks)
            {
                SetAdjacentChunksToUpdate(chunkPositionInWorld, updatedBlockPositionInChunk);
            }

            return didSetBlock;
        }

        private void SetAdjacentChunksToUpdate(Point3D chunkPositionInWorld, Point3D updatedBlockPositionInChunk)
        {
            if (updatedBlockPositionInChunk.X == 0)
            {
                var adjacentChunkPosition = new Point3D(chunkPositionInWorld.X - Chunk.Width, chunkPositionInWorld.Y, chunkPositionInWorld.Z);
                UpdateChunk(adjacentChunkPosition);
            }

            if (updatedBlockPositionInChunk.X == Chunk.Width - 1)
            {
                var adjacentChunkPosition = new Point3D(chunkPositionInWorld.X + Chunk.Width, chunkPositionInWorld.Y, chunkPositionInWorld.Z);
                UpdateChunk(adjacentChunkPosition);
            }

            if (updatedBlockPositionInChunk.Y == 0)
            {
                var adjacentChunkPosition = new Point3D(chunkPositionInWorld.X, chunkPositionInWorld.Y - Chunk.Height, chunkPositionInWorld.Z);
                UpdateChunk(adjacentChunkPosition);
            }

            if (updatedBlockPositionInChunk.Y == Chunk.Height - 1)
            {
                var adjacentChunkPosition = new Point3D(chunkPositionInWorld.X, chunkPositionInWorld.Y + Chunk.Height, chunkPositionInWorld.Z);
                UpdateChunk(adjacentChunkPosition);
            }

            if (updatedBlockPositionInChunk.Z == 0)
            {
                var adjacentChunkPosition = new Point3D(chunkPositionInWorld.X, chunkPositionInWorld.Y, chunkPositionInWorld.Z - Chunk.Depth);
                UpdateChunk(adjacentChunkPosition);
            }

            if (updatedBlockPositionInChunk.Z == Chunk.Depth - 1)
            {
                var adjacentChunkPosition = new Point3D(chunkPositionInWorld.X, chunkPositionInWorld.Y, chunkPositionInWorld.Z + Chunk.Depth);
                UpdateChunk(adjacentChunkPosition);
            }
        }

        private void UpdateChunk(Point3D chunkPositionInWorld)
        {
            var chunk = GetChunk(chunkPositionInWorld);
            if (chunk != null)
            {
                chunk.Update = true;
            }
        }

        private static Point3D GetChunkPositionInWorld(Point3D worldPosition)
        {
            var x = Mathf.FloorToInt(worldPosition.X / (float)Chunk.Width) * Chunk.Width;
            var y = Mathf.FloorToInt(worldPosition.Y / (float)Chunk.Height) * Chunk.Height;
            var z = Mathf.FloorToInt(worldPosition.Z / (float)Chunk.Depth) * Chunk.Depth;
            return new Point3D(x, y, z);
        }

        private static Point3D GetBlockPositionInChunk(Point3D blockPosition, Point3D chunkPosition)
        {
            var x = blockPosition.X - chunkPosition.X;
            var y = blockPosition.Y - chunkPosition.Y;
            var z = blockPosition.Z - chunkPosition.Z;
            return new Point3D(x, y, z);
        }
    }
}
