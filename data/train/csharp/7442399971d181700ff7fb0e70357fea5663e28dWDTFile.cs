using System;
using W3DT.Formats.WDT;

namespace W3DT.Formats
{
    public class WDTException : Exception
    {
        public WDTException(string message) : base(message) { }
    }

    public class WDTFile : ChunkedFormatBase
    {
        public WDTFile(string file) : base(file) { }

        public override void storeChunk(Chunk_Base chunk)
        {
            Chunks.Add(chunk);
        }

        public override Chunk_Base lookupChunk(UInt32 magic)
        {
            switch (magic)
            {
                case Chunk_MVER.Magic: return new Chunk_MVER(this);
                case Chunk_MPHD.Magic: return new Chunk_MPHD(this);
                case Chunk_MAIN.Magic: return new Chunk_MAIN(this);
                case Chunk_MWMO.Magic: return new Chunk_MWMO(this);
                case Chunk_MODF.Magic: return new Chunk_MODF(this);
                default: return new Chunk_Base(this);
            }
        }

        public override string getFormatName()
        {
            return "WDT";
        }
    }
}
