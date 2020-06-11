using UnityEngine;
using System.Collections.Generic;

namespace Voxels
{
    public class WorldData
    {
        public string name = "default";
        public readonly Dictionary<WorldPos, ChunkData> chunks;

        public WorldData()
        {
            chunks = new Dictionary<WorldPos, ChunkData>();
        }

        public WorldPos GetChunkPos(int x, int y, int z)
        {
            var px = Mathf.FloorToInt(x / MapConstants.ChunkSizeFloat) * MapConstants.ChunkSize;
            var py = Mathf.FloorToInt(y / MapConstants.ChunkSizeFloat) * MapConstants.ChunkSize;
            var pz = Mathf.FloorToInt(z / MapConstants.ChunkSizeFloat) * MapConstants.ChunkSize;

            return new WorldPos(px, py, pz);
        }

        public ChunkData GetChunkData(int x, int y, int z)
        {
            var pos = GetChunkPos(x, y, z);

            ChunkData chunk;
            chunks.TryGetValue(pos, out chunk);

            return chunk;
        }

        public ChunkData CreateChunk(int x, int y, int z)
        {
            WorldPos pos = GetChunkPos(x, y, z);

            var chunk = new ChunkData(pos);

            chunks.Add(pos, chunk);

            return chunk;
        }

        public void DestroyChunk(int x, int y, int z)
        {
            var pos = GetChunkPos(x, y, z);

            ChunkData chunk;
            if (chunks.TryGetValue(pos, out chunk))
            {
                chunks.Remove(pos);
            }
        }

        public BlockId GetBlock(int x, int y, int z)
        {
            var chunk = GetChunkData(x, y, z);
            if (chunk == null)
            {
                return BlockId.Air;
            }

            return chunk.GetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z);
        }

        public void SetBlock(int x, int y, int z, BlockId blockId)
        {
            var chunk = GetChunkData(x, y, z);
            if (chunk == null)
            {
                chunk = CreateChunk(x, y, z);
            }

            chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, blockId);
        }
    }
}