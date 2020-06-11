using UnityEngine;
using System.Collections;

public static class TerrainGen
{
    public static FastNoiseSIMD FastNoise {
        get {
            if (fastNoise != null) {
                return fastNoise;
            }

            fastNoise = new FastNoiseSIMD();
            return fastNoise;
        }
        set { fastNoise = value; }
    }

    static FastNoiseSIMD fastNoise;

    static int stoneBaseHeight = 40;
    static int stoneVarHeight = 16;
    static int dirtVarHeight = 10;



    public static Chunk ChunkGen(Chunk chunk)
    {
        for (int x = chunk.pos.x; x < chunk.pos.x + Chunk.chunkSize; x++)
        {
            for (int z = chunk.pos.z; z < chunk.pos.z + Chunk.chunkSize; z++)
            {
                chunk = ChunkColumnGen(chunk, x, z);
            }
        }
        return chunk;
    }


    public static Chunk ChunkColumnGen(Chunk chunk, int x, int z)
    {
        /*int stoneHeight = GetNoise(x, 0, z, stoneVarHeight) + stoneBaseHeight;
        int dirtHeight = GetNoise(x, 10, z, dirtVarHeight) + stoneHeight + 1;
        Biome biome = GetBiome(x, 20, z);*/

        for (int y = chunk.pos.y; y < chunk.pos.y + Chunk.chunkSize; y++)
        {
            /*if (y <= stoneHeight || (biome == Biome.Stone && y <= dirtHeight))
            {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new Block());
            }
            else if (y <= dirtHeight)
            {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockGrass());
            }
            else
            {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockAir());
            }*/
            if (y < 32) {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockGrass());
            }
            else
            {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockAir());
            }
                
        }
        return chunk;
    }


    public static int GetNoise(int x, int y, int z, int max)
    {
        return Mathf.CeilToInt((FastNoise.GetNoiseSet(x, y, z, 1, 1, 1)[0] + 1) / 2 * max);
    }

    public static Biome GetBiome(int x, int y, int z)
    {
        switch(GetNoise(x, y, z, 2))
        {
            case 1:
                return Biome.Grass;
            case 2:
                return Biome.Stone;
        }

        return Biome.Grass;
    }

    public enum Biome
    {
        Grass,
        Stone
    }
}