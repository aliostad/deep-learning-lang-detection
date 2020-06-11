using System;
using System.Collections.Generic;

namespace Breeze.Game
{
    public class EntityChunkCollection : ChunkCollection<Entity>
    {
        public EntityChunkCollection(int chunkSize)
            : base(chunkSize)
        {
        }

        public override void ValidateChunkAt(int x, int y)
        {
            ChunkAddress addr = new ChunkAddress() { X = x / ChunkSize, Y = y / ChunkSize };

            if (!Chunks.ContainsKey(addr))
                return;

            var toRemove = new LinkedList<Entity>();
            var chunk = Chunks[addr];

            foreach (Entity e in chunk)
            {
                if (!addr.Equals(new ChunkAddress() { X = (int)e.X, Y = (int)e.Y }))
                    toRemove.AddLast(e);
            }

            foreach (Entity e in toRemove)
            {
                chunk.Remove(e);
                InsertAt(e, (int)e.X, (int)e.Y);
            }
        }
    }
}

