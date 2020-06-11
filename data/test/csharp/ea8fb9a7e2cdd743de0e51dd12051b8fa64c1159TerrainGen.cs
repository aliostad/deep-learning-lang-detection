using UnityEngine;
using System.Collections;
using SimplexNoise;

public class TerrainGen
{

    public static Chunk ChunkGen(Chunk chunk)
    {
        for (int x = chunk.pos.x; x < chunk.pos.x + Chunk.chunkSize; x++)
            for (int z = chunk.pos.z; z < chunk.pos.z + Chunk.chunkSize; z++)
                chunk = ChunkColumnGen(chunk, x, z);
            
        return chunk;
    }

    public static Chunk ChunkColumnGen(Chunk chunk, int x, int z)
    {
        int height = TerrainManager.instance.heightMap[x, z];
        bool isRiver = TerrainManager.instance.river[x, z];

        for (int y = 0; y < Chunk.chunkSize; y++)
        {
            if (y + chunk.pos.y <= TerrainManager.instance.waterLevel)
                chunk.SetBlock(x - chunk.pos.x, y, z - chunk.pos.z, new BlockWater());
            else if (y + chunk.pos.y < height)
                chunk.SetBlock(x - chunk.pos.x, y, z - chunk.pos.z, DetermineBlock(x, z, false, isRiver));
            else if (y + chunk.pos.y == height)
                chunk.SetBlock(x - chunk.pos.x, y, z - chunk.pos.z, BlockConfig.instance.DetermineChoice(GridManager.instance.GetGridLocation(x,z))); 
            else
                chunk.SetBlock(x - chunk.pos.x, y, z - chunk.pos.z, new BlockAir()); 
        }

        return chunk;
    }

    static Block DetermineBlock(int x, int z, bool top, bool isRiver)
    {
        float soil = TerrainManager.instance.soilQualityMap[x, z];
        float moisture = TerrainManager.instance.moistureMap[x, z];
        int height = TerrainManager.instance.heightMap[x, z];

        if (isRiver)
            return new BlockWater();
        else if (top)
        {
            if (soil < 0.6f && moisture < 0.6f && height <= TerrainManager.instance.waterLevel + 2)
                return new BlockSand();
            else
                return new BlockGrass();
        }
            
        else
            return new Block();
    }

}