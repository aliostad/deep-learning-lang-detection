using Arcodia.Worlds.Chunks;
using System.Collections.Generic;

namespace Arcodia.Worlds
{
    public class WorldProvider
    {
        private readonly World WorldObj;

        private readonly Dictionary<ChunkPos, Chunk> LoadedChunks = new Dictionary<ChunkPos, Chunk>();

        public WorldProvider(World world)
        {
            this.WorldObj = world;
        }

        #region Chunk Management

        public Chunk GetChunk(int x, int y, int z)
        {
            return this.GetChunk(new ChunkPos(x, y, z));
        }

        public Chunk GetChunk(ChunkPos pos)
        {
            Chunk chunk;
            this.LoadedChunks.TryGetValue(pos, out chunk);

            if (chunk == null)
            {
                chunk = this.LoadOrCreateChunk(pos);
                this.LoadedChunks.Add(pos, chunk);
            }

            return chunk;
        }

        public Chunk LoadOrCreateChunk(ChunkPos pos)
        {
            return new Chunk(this.WorldObj, pos);
        }

        #endregion
    }
}