using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.ComponentModel;

namespace WestWood3D.Chunks
{
    public class EmitterChunk : Chunk
    {
        public EmitterChunk()
        {
        }

        public override void parse(BinaryReader br, ChunkMap chkMap, Boolean dbg, int chunkLength)
        {
            if (dbg) Console.Out.WriteLine("|-| " + ChunkHeader.W3D_CHUNK_EMITTER);

            HeaderID = (int)ChunkHeader.W3D_CHUNK_EMITTER;
            HeaderName = ChunkHeader.W3D_CHUNK_EMITTER.ToString();
        }
    }
}
