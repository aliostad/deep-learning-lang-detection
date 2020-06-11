using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicAnalysis
{
    internal struct ChunkDescriptor
    {
        private byte[] _chunkID;
        private byte[] _chunkSize;
        private byte[] _format;

        public ChunkDescriptor(byte[] rawChunkDescriptor)
        {
            _chunkID = rawChunkDescriptor.
        }

        public byte[] ChunkID => _chunkID;
        public byte[] ChunkSize => _chunkSize;
        public byte[] Format => _format; 
    }
}
