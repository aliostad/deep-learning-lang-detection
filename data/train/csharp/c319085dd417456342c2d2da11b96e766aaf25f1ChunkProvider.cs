using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace mcsharpbot.communication
{
    public class ChunkProvider
    {
        public Hashtable Chunks;

        public ChunkProvider()
        {
            Chunks = new Hashtable();
        }

        public Chunk AllocateChunk(int X, int Y)
        {
            ChunkCoordinates chunkCoords = new ChunkCoordinates(X, Y);
            byte[] blocks = new byte[32768];
            Chunk chunk = new Chunk(blocks, X, Y);
            for (int i = 0; i < chunk.SkylightMap.data.Length; i++)
            {
                chunk.SkylightMap.data[i] = 255;
            }
            Chunks.Add(chunkCoords, chunk);
            return chunk;
        }

        public Chunk GetFromCoordinates(int X, int Y)
        {
            Chunk c = (Chunk)Chunks[new ChunkCoordinates(X, Y)];
            if(c == null) 
            {
                return new Chunk(new byte[32768], 0, 0);
            } 
            else 
            {
                return c;
            }
        }

        public Blocks GetBlock(int X, int Y, int Z)
        {
            if (Y < 0)
            {
                return Blocks.Bedrock;
            }
            if (Y >= Chunk.Height)
            {
                return Blocks.Air;
            }
            Chunk chunk = GetFromCoordinates(X >> 4, Y >> 4);

            return chunk.GetBlockID(X & 0xf, Y, Z & 0xf);

        }

    }
}
