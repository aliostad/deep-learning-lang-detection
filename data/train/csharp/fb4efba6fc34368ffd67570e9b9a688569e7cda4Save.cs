using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

[Serializable]
public class Save
{
    public Dictionary<Vector3, Block> blocks = new Dictionary<Vector3, Block>();

    public Save(Chunk chunk)
    {
        for (int x = 0; x < Chunk.chunkSize; x++)
        {
            for (int y = 0; y < Chunk.chunkSize; y++)
            {
                for (int z = 0; z < Chunk.chunkSize; z++)
                {
                    if (!chunk.blocks[x, y, z].changed)
                    {
                        continue;
                    }

                    Vector3 pos = new Vector3(x, y, z);
                    blocks.Add(pos, chunk.blocks[x, y, z]);
                }
            }
        }
    }
}
