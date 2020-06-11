using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;

namespace Terrain_Scanner_Automation
{
    public class ChunkList
    {
        public event EventHandler<EventArgs> RemoveChunk;

        public struct Chunk
        {
            public int X { get; private set; }
            public int Z { get; private set; }

            public Chunk(int x, int z)
            {
                X = x;
                Z = z;
            }

            public override string ToString()
            {
                return X + " " + Z;
            }
        }

        public BindingList<Chunk> Chunks;

        public ChunkList()
        {
            Chunks = new BindingList<Chunk>();
        }

        public Chunk AddChunk(int x, int z)
        {
            Chunk chunk = new Chunk(x, z);

            if (!Chunks.Any(c => c.Equals(chunk)))
            {
                Chunks.Add(chunk);
                Console.WriteLine("Chunk Added: (" + x + ", " + z + ")");
            }

            return chunk;
        }

        public Chunk GetAndRemoveFirstChunk()
        {
            Chunk chunk = Chunks.FirstOrDefault();
            if (!chunk.Equals(null))
            {
                RemoveChunk(this, EventArgs.Empty);
            }

            return chunk;
        }

    }
}
