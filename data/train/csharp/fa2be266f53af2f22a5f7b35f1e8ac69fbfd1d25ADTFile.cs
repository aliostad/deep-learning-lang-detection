using System;
using System.Collections.Generic;
using System.Linq;
using W3DT.Formats.ADT;

namespace W3DT.Formats
{
    public enum ADTFileType
    {
        ROOT,
        TEX,
        OBJ,
        LOD
    }

    public class ADTException : Exception
    {
        public ADTException(string message) : base(message) { }
    }

    public class ADTFile : ChunkedFormatBase, IChunkProvider
    {
        public static float TILE_SIZE = 4.16675f;
        public ADTFileType Type { get; private set; }
        private Chunk_MCNK CurrentSub;

        public ADTFile(string file, ADTFileType type) : base(file)
        {
            Type = type;
        }

        public override void storeChunk(Chunk_Base chunk)
        {
            if (chunk is IChunkSoup)
            {
                if (CurrentSub != null)
                    CurrentSub.addChunk(chunk);
                else
                    Log.Write("ADT: Sub-chunk found before MCNK chunk? Shun the demons!");
            }
            else
            {
                Chunks.Add(chunk);

                if (chunk is Chunk_MCNK)
                    CurrentSub = (Chunk_MCNK)chunk;
            }
        }

        public override Chunk_Base lookupChunk(UInt32 magic)
        {
            switch (magic)
            {
                case Chunk_MVER.Magic: return new Chunk_MVER(this);
                case Chunk_MCNK.Magic: return new Chunk_MCNK(this);
                case Chunk_MTEX.Magic: return new Chunk_MTEX(this);
                case Chunk_MMDX.Magic: return new Chunk_MMDX(this);
                case Chunk_MMID.Magic: return new Chunk_MMID(this);
                case Chunk_MWMO.Magic: return new Chunk_MWMO(this);
                case Chunk_MWID.Magic: return new Chunk_MWID(this);
                case Chunk_MDDF.Magic: return new Chunk_MDDF(this);
                case Chunk_MODF.Magic: return new Chunk_MODF(this);
                case Chunk_MCVT.Magic: return new Chunk_MCVT(this);
                case Chunk_MCLV.Magic: return new Chunk_MCLV(this);
                case Chunk_MCCV.Magic: return new Chunk_MCCV(this);
                case Chunk_MCNR.Magic: return new Chunk_MCNR(this);
                case Chunk_MCLY.Magic: return new Chunk_MCLY(this);
                case Chunk_MCRD.Magic: return new Chunk_MCRD(this);
                case Chunk_MCRW.Magic: return new Chunk_MCRW(this);
                case Chunk_MCAL.Magic: return new Chunk_MCAL(this);
                default: return new Chunk_Base(this);
            }
        }

        public override string getFormatName()
        {
            return "ADT";
        }

        public Chunk_Base getChunk(UInt32 chunkID, bool error = true)
        {
            Chunk_Base chunk = getChunksByID(chunkID).FirstOrDefault();
            if (chunk == null && error)
                throw new ADTException(string.Format("File does not contain chunk 0x{0}.", chunkID.ToString("X")));

            return chunk;
        }

        public IEnumerable<Chunk_Base> getChunksByID(UInt32 chunkID)
        {
            return Chunks.Where(c => c.ChunkID == chunkID);
        }

        public IEnumerable<Chunk_Base> getChunks()
        {
            return Chunks;
        }
    }
}
