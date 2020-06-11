using Assets.Scripts.Framework.Utils.Vector;
using Assets.Scripts.Game.Component.Terrain.Block;

namespace Assets.Scripts.Game.Component.Terrain.Chunk
{
    public static class ChunkFactory
    {
        public static ChunkEntity CreateChunk(IntVector3 position = default(IntVector3))
        {
            var chunk = new ChunkEntity();

            chunk.Initialise(position);

            return chunk;
        }

        public static ChunkEntity CreateFlatGrassChunk(IntVector3 position = default(IntVector3))
        {
            var chunk = new ChunkEntity();

            for (int x = 0; x < ChunkEntity.ChunkSize; x++)
            {
                for (int y = 0; y < ChunkEntity.ChunkSize; y++)
                {
                    for (int z = 0; z < ChunkEntity.ChunkSize; z++)
                    {
                        chunk.SetBlock(new GrassBlock(chunk, new IntVector3(x, y, z)));
                    }
                }
            }

            chunk.Initialise(position);

            return chunk;
        }
    }
}
