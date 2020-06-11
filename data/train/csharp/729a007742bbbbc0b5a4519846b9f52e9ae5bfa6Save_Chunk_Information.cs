using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

[Serializable]
public class Save_Chunk_Information
{
    public Dictionary<Position_In_World, Voxel> blocks = new Dictionary<Position_In_World, Voxel>();

    public Save_Chunk_Information(Chunk_Information chunk)
    {
        for (int x = 0; x < Chunk_Information.chunkSize; x++)
        {
            for (int y = 0; y < Chunk_Information.chunkSize; y++)
            {
                for (int z = 0; z < Chunk_Information.chunkSize; z++)
                {
                    if (!chunk.blocks[x, y, z].changed)
                        continue;

                    Position_In_World pos = new Position_In_World(x, y, z);
                    blocks.Add(pos, chunk.blocks[x, y, z]);
                }
            }
        }
    }
}
