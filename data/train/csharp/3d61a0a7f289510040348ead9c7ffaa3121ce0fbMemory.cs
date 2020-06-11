using System;
using System.Collections.Generic;
using System.Threading;

namespace Brainf
{
    public class Memory
    {
        const int ChunkSize = 0x1000;
        const int ChunkIndexShift = 12;

        Dictionary<int, byte[]> chunks = new Dictionary<int, byte[]>();        

        internal Memory()
        {
        }

        public byte this[int index]
        {
            get
            {
                int indexInChunk = index & (ChunkSize - 1);
                int chunkIndex = index >> ChunkIndexShift;
                byte[] chunk;
                if (chunks.TryGetValue(chunkIndex, out chunk))
                    return chunk[indexInChunk];
                else
                    return 0;
            }
            set
            {
                int indexInChunk = index & (ChunkSize - 1);
                int chunkIndex = index >> ChunkIndexShift;
                byte[] chunk;
                if (!chunks.TryGetValue(chunkIndex, out chunk))
                    chunks.Add(chunkIndex, chunk = new byte[ChunkSize]);
                chunk[indexInChunk] = value;
            }
        }
    }
}
