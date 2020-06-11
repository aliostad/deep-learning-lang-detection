using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Text;


public static class GenericChunkGen
{
    public static void GenerateChunk(Chunk chunk)
    {
        for (int x = 0; x < CONST.chunkSize.x; x++)
        {
            for (int y = 0; y < CONST.chunkSize.y; y++)
            {
                for (int z = 0; z < CONST.chunkSize.z; z++)
                {

                        chunk.blocks[x, y, z].blockType = BlockType.Dirt;
                }
            }
        }
            
    }
}

