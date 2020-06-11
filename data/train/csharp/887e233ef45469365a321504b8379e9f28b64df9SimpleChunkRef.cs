using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Substrate;
using Substrate.Core;

namespace mca2vmf.VolxClasses
{
    public class SimpleChunkRef
    {
        public int ChunkX;
        public int ChunkY;
        public IChunk Chunk;

        public SimpleChunkRef(int X, int Y)
        {
            ChunkX = X;
            ChunkX = Y;
        }

        public SimpleChunkRef(int X, int Y, IChunk chunk)
        {
            ChunkX = X;
            ChunkX = Y;
            Chunk = chunk;
        }
    }
}
