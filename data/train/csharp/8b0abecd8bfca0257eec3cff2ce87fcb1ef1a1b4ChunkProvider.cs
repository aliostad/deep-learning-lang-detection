using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cubix.world {
    public class ChunkProvider : IChunkProvider {

        private IChunkProvider childProvider;
        private Dictionary<long, Chunk> loadedChunksArray = new Dictionary<long, Chunk>();

        public ChunkProvider(IChunkProvider childProvider) {
            this.childProvider = childProvider;
        }

        public Chunk provideChunk(int x, int z) {
            Chunk chunk = null;

            long chunkPosition = Chunk.chunkXZ2Int(x, z);

            if (this.loadedChunksArray.ContainsKey(chunkPosition)) {
                this.loadedChunksArray.TryGetValue(chunkPosition, out chunk);
            } else {
                chunk = this.childProvider.provideChunk(x, z);
                this.loadedChunksArray.Add(chunkPosition, chunk);
            }

            return chunk;
        }
    }
}
