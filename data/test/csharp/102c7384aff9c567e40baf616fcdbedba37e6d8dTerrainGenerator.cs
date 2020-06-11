using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Blocks;
using UnityEngine;

namespace Assets.TerrainGen
{
    public class TerrainGenerator
    {
        private const int BaseHeight = 0;
        private const int MaxHeight = 10;
        private const float Scale = 0.04f;

        public Chunk GenerateChunk(Chunk chunk)
        {
            for (var x = chunk.WorldPos.X; x < chunk.WorldPos.X + Chunk.ChunkSize; x++)
            {
                for (var z = chunk.WorldPos.Z; z < chunk.WorldPos.Z + Chunk.ChunkSize; z++)
                {
                    GenerateChunkColumn(chunk, x, z);
                }
            }

            return chunk;
        }

        private void GenerateChunkColumn(Chunk chunk, int x, int z)
        {
            var height = BaseHeight;
            height += GetNoise(x, 0, z, Scale, MaxHeight);
            for (var y = chunk.WorldPos.Y; y < chunk.WorldPos.Y + Chunk.ChunkSize; y++)
            {
                if (y == height)
                {
                    chunk.SetBlock<Block>(x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z);
                    chunk[x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z].Light = Block.MaxLight;
                }
                else if (y < height)
                {
                    chunk.SetBlock<Block>(x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z);
                }
                else
                {
                    chunk.SetBlock<BlockAir>(x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z);
                    chunk[x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z].Light = Block.MaxLight;
                }
            }
        }

        private static int GetNoise(int x, int y, int z, float scale, int max)
        {
            return Mathf.FloorToInt((SimplexNoise.Generate(x * scale, y * scale, z * scale) + 1f) * (max / 2f));
        }
    }
}
