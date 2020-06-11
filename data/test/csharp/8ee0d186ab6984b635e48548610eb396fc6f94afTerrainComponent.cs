using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

using Assets.Scripts.Framework.Component;
using Assets.Scripts.Framework.Utils.Extensions;
using Assets.Scripts.Framework.Utils.Vector;
using Assets.Scripts.Game.Component.Terrain.Block;
using Assets.Scripts.Game.Component.Terrain.Chunk;

namespace Assets.Scripts.Game.Component.Terrain
{
    public class TerrainComponent : AbstractGameComponent
    {
        public Dictionary<IntVector3, ChunkEntity> Chunks { get; set; }

        public TerrainComponent()
        {
            Chunks = new Dictionary<IntVector3, ChunkEntity>();
        }

        public void Initialise()
        {
            for (int x = 0; x < 2; x++)
            {
                for (int y = 0; y < 2; y++)
                {
                    for (int z = 0; z < 2; z++)
                    {
                        AddChunk(new IntVector3(x * ChunkEntity.ChunkSize, y * ChunkEntity.ChunkSize, z * ChunkEntity.ChunkSize));
                    }
                }
            }

            new Thread(() => Chunks.Values.ToList().ForEach(ch => ch.UpdateChunk())).Start();
        }

        public void AddChunk(IntVector3 position)
        {
            Chunks[position] = ChunkFactory.CreateFlatGrassChunk(position);
        }

        public void DestroyChunk(IntVector3 position)
        {
            DestroyChunk(Chunks[position]);
        }

        public void DestroyChunk(ChunkEntity chunk)
        {
            chunk.Destroy();
            Chunks[chunk.Position] = null;
        }

        public override void LateUpdate(float dt)
        {
            foreach (var chunk in Chunks.Values) chunk.RenderChunk();
        }

        public ChunkEntity GetChunk(IntVector3 worldPositon)
        {
            var chunkPosition = worldPositon.GetChunkPosition(ChunkEntity.ChunkSize);

            return Chunks.ContainsKey(chunkPosition) ? Chunks[chunkPosition] : null;
        }

        public IBlock GetBlock(IntVector3 worldPosition)
        {
            var chunk = GetChunk(worldPosition);

            return chunk != null ? chunk.GetBlock(worldPosition - chunk.Position) : new AirBlock();
        }
    }
}
