using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Beer.World.Interfaces;


namespace Beer.World
{
    private class CacheKey
    {
        public int x;
        public int y;
    }


    public class ChunkCache: IChunkCache
    {
        public ChunkUpdated OnChunkUpdate;
        private IChunkLoader _chunkLoader;
        private Dictionary<CacheKey, Chunk> _cache;


        public ChunkCache(IChunkLoader loader)
        {
            _chunkLoader = loader;
        }

        private CacheKey GetKey(int x, int y)
        {
            CacheKey key = new CacheKey();
            key.x = x;
            key.y = y;
            return key;
        }

        public void GetChunk(int x, int y)
        {
            CacheKey key = GetKey(x, y);

            Chunk stored = _cache[key];

            if (stored == null)
                stored = _chunkLoader.LoadChunk(x, y);

            OnChunkUpdate(stored);
        }

        public void UpdateChunk(Chunk changedChunk)
        {
            _cache[GetKey(changedChunk.x, changedChunk.y)] = changedChunk;
            OnChunkUpdate(changedChunk);
        }
    }
}
