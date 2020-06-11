using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MorseProject
{
    class HeaderChunk : WaveChunk
    {
        public char[] RiffType { get; set; }
        public FormatChunk FormatChunk { get; set; }
        public DataChunk DataChunk { get; set; }

        public HeaderChunk(FormatChunk formatChunk, DataChunk dataChunk)
        {
            ChunkId = "RIFF".ToCharArray();
            RiffType = "WAVE".ToCharArray();
            FormatChunk = formatChunk;
            DataChunk = dataChunk;
            ChunkSize = 36 + DataChunk.ChunkSize;
        }

        public override byte[] ToBytes()
        {
            List<byte> bytes = new List<byte>();

            bytes.AddRange(Encoding.UTF8.GetBytes(ChunkId));
            bytes.AddRange(BitConverter.GetBytes(ChunkSize));
            bytes.AddRange(Encoding.UTF8.GetBytes(RiffType));
            bytes.AddRange(FormatChunk.ToBytes());
            bytes.AddRange(DataChunk.ToBytes());

            return bytes.ToArray<byte>();
        }
    }
}
