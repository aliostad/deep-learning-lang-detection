using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ParseWav_20170927
{
    class Chunk
    {
        public string ChunkID { get; private set; } = string.Empty;
        public UInt32 ChunkSize { get; private set; } = 0;
        public byte[] ChunkData { get; private set; }
        public byte[] Rest { get; private set; }
        public Chunk(byte[] chunk, bool isRiff)
        {
            ChunkID = new string(chunk.Take(4).Select(x=>(char)x).ToArray());
            ChunkSize = BitConverter.ToUInt32(chunk, 4);
            if (isRiff)
            {
                ChunkData = new byte[4];
                Array.Copy(chunk, 8, ChunkData, 0, 4);
            }
            else
            {
                ChunkData = new byte[ChunkSize];
                Array.Copy(chunk, 8, ChunkData, 0, ChunkSize);
            }
        }        
    }
}
