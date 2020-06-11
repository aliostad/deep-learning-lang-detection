using System;
using Microsoft.Xna.Framework;

namespace BananaTheGame.Terrain.Generators
{
    public class TestTerrainGenerator : IChunkGenerator
    {
        public void Generate(Chunk chunk)
        {
            //generate(chunk);
            testGroundGen(chunk);
        }

        private void testGroundGen(Chunk chunk)
        {
            for (byte x = 0; x < Chunk.SIZE; x++)
            {
                for (byte y = 0; y < Chunk.SIZE; y++)
                {
                    Tile tile = new Tile(TileType.Grass, new Vector2Int(x, y));
                    chunk.Add(tile);
                }
            }
        }
    }
}
