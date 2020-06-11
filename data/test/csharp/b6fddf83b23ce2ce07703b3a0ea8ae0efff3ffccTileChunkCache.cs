using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Assets.Scripts.Model.Tiles
{
    class TileChunkCache
    {
        private TileChunk cachedChunk = null;

        private TileChunkProvider chunkProvider;

        public TileChunkCache()
        {
            chunkProvider = new TileChunkProvider();
        }

        public TileChunk LoadTileChunk(long chunkId)
        {
            cachedChunk = cachedChunk ?? chunkProvider.LoadChunk(chunkId);
            return cachedChunk;
        }
    }
}
