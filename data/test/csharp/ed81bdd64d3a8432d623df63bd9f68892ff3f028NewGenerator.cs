using GameLib;
using JumpAndRun.API;
using JumpAndRun.TerrainGeneration;
using System;

namespace JumpAndRun.Content.TerrainGeneration.Generators
{
    public class NewGenerator : IWorldGenerator
    {
        public int Seed { get; }

        public NewGenerator(int seed)
        {
            Seed = seed;
        }

        private static IBiom BiomForColumn(int column)
        {
            return ContentManager.Instance.Biomes[Math.Abs(column / 6) % 2];
        }

        public Chunk GenerateChunk(Index2 position)
        {
            var chunk = new Chunk(position, 1);

            IBiom biom = BiomForColumn(position.X);

            var heightmap0 = new int[Chunk.Sizex];
            for (var i = 0; i < Chunk.Sizex; i++)
            {
                heightmap0[i] = BiomForColumn(position.X - 1).GetHeight(i + (position.X - 1) * Chunk.Sizex);
            }

            var heightmap1 = new int[Chunk.Sizex];
            for (var i = 0; i < Chunk.Sizex; i++)
            {
                heightmap1[i] = BiomForColumn(position.X).GetHeight(i + position.X * Chunk.Sizex);
            }

            bool useInterpolate = BiomForColumn(position.X) != BiomForColumn(position.X - 1);
                
            var heightmap = new int[Chunk.Sizex];
            for (var i = 0; i < Chunk.Sizex; i++)
            {
                int map0 = (int)(heightmap0[i] * (-(1 / (float)Chunk.Sizex) * i + 1));
                int map1 = (int)(heightmap1[i] * 1 / (float)Chunk.Sizex * i);

                heightmap[i] = useInterpolate ? map0 + map1 : heightmap1[i];
            }

            var maxBiomHeight = GameLib.Helper.ArrayMax(heightmap);
            var minBiomHeight = GameLib.Helper.ArrayMin(heightmap);

            if (maxBiomHeight < position.Y * Chunk.Sizey)
            {
                for (var x = 0; x < Chunk.Sizex; x++)
                {
                    for (var y = 0; y < Chunk.Sizey; y++)
                    {
                        SetBlock(chunk, null, x, y);
                    }
                }
            }
            else if (minBiomHeight >= (position.Y + 1) * Chunk.Sizey)
            {
                for (var x = 0; x < Chunk.Sizex; x++)
                {
                    for (var y = 0; y < Chunk.Sizey; y++)
                    {
                        SetBlock(chunk, biom.Filler, x, y);
                    }
                }
            }
            else
            {
                for (var x = 0; x < Chunk.Sizex; x++)
                {
                    var height = heightmap[x];
                    var chunkHeight = height - Chunk.Sizey * position.Y;
                    if (height > position.Y * Chunk.Sizey && height < (position.Y + 1) * Chunk.Sizey)
                    {
                        SetBlock(chunk, biom.Surface, x, chunkHeight);
                        for (var y = 0; y < chunkHeight; y++)
                        {
                            SetBlock(chunk, biom.Filler, x, y);
                        }

                        for (var y = chunkHeight + 1; y < Chunk.Sizey; y++)
                        {
                            SetBlock(chunk, null, x, y);
                        }
                    }
                    else if(height <= position.Y * Chunk.Sizey)
                    {
                        for (var y = 0; y < Chunk.Sizey; y++)
                        {
                            SetBlock(chunk, null, x, y);
                        }
                    }
                    else if (height >= (position.Y + 1) * Chunk.Sizey)
                    {
                        for (var y = 0; y < Chunk.Sizey; y++)
                        {
                            SetBlock(chunk, biom.Filler, x, y);
                        }
                    }
                }
            }
            return chunk;
        }

        private static void SetBlock(Chunk chunk, IBlock block, int x, int y)
        {
            chunk.SetBlock(block, x, y, 0);
            chunk.SetBlock(block, x, y, 1);
            chunk.SetBlock(block, x, y, 2);
            if(y != Chunk.Sizey - 1)
                chunk.SetBlock(block, x, y + 1, 2);
        }
    }
}
