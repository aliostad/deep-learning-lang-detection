using System.Collections.Generic;

namespace Bawx.VoxelData
{
    public class ChunkCollection
    {
        public readonly List<Chunk> Chunks;

        public Chunk this[int i] => Chunks[i];

        public ChunkCollection()
        {
            Chunks = new List<Chunk>();
        }

        public ChunkCollection(List<Chunk> chunks)
        {
            Chunks = chunks;
        }

        public void Draw()
        {
            foreach (var chunk in Chunks)
                chunk.Draw();
        }
    }
}