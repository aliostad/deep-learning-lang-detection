using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WindowsFormsApplication7.CrossCutting.Entities;

namespace WindowsFormsApplication7.DataAccess
{
    class ChunkStorage
    {
        Dictionary<object, Chunk> chunks = new Dictionary<object, Chunk>();
        
        internal Chunk GetChunk(PositionChunk positionChunk)
        {
            if (chunks.ContainsKey(positionChunk.Key))
                return chunks[positionChunk.Key];
            return null;
        }

        internal void AddChunk(Chunk chunk)
        {
            chunks.Add(chunk.Position.Key, chunk);
        }
    }
}
