using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TechnoloCity.Base
{
    class World
    {
        public World()
        {
            this.chunks = new Dictionary<Vector3i, Chunk>();
        }

        public Block GetBlock(int x, int y, int z)
        {
            Block block = null;
            var chunkPosition = ChunkInWorld(x, y, z);
            var blockPosition = BlockInChunk(x, y, z);
            Chunk chunk;
            if (chunks.TryGetValue(chunkPosition, out chunk))
            {
                block = chunk.GetBlock(blockPosition.X, blockPosition.Y, blockPosition.Z);
            }
            return block;
        }

        public void SetBlock(int x, int y, int z, Block block)
        {
            var chunkPosition = ChunkInWorld(x, y, z);
            var blockPosition = BlockInChunk(x, y, z);

            Chunk chunk;
            if (!chunks.TryGetValue(chunkPosition, out chunk))
            {
                chunk = new Chunk();
                chunks[chunkPosition] = chunk;
            }

            chunk.SetBlock(blockPosition.X, blockPosition.Y, blockPosition.Z, block);
        }

        public Dictionary<Vector3i, Chunk> chunks;

        public static Vector3i ChunkInWorld(int x, int y, int z) => new Vector3i(
            x < 0 ? (x + 1) / Chunk.Size - 1 : x / Chunk.Size,
            y < 0 ? (y + 1) / Chunk.Size - 1 : y / Chunk.Size,
            z < 0 ? (z + 1) / Chunk.Size - 1 : z / Chunk.Size);

        public static Vector3i BlockInChunk(int x, int y, int z) => new Vector3i(
            x < 0 ? (x + 1) % Chunk.Size + Chunk.Size - 1 : x % Chunk.Size,
            y < 0 ? (y + 1) % Chunk.Size + Chunk.Size - 1 : y % Chunk.Size,
            z < 0 ? (z + 1) % Chunk.Size + Chunk.Size - 1 : z % Chunk.Size);
    }
}
