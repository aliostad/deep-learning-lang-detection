using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

[Serializable]
public class ChunkSaveData
{
    public Dictionary<WorldPos, BlockInstance> blocks = new Dictionary<WorldPos, BlockInstance>();

    public ChunkSaveData(Chunk chunk)
    {
        for (int x = 0; x < Chunk.CHUNK_SIZE; x++)
        {
            for (int y = 0; y < Chunk.CHUNK_SIZE; y++)
            {
                for (int z = 0; z < Chunk.CHUNK_SIZE; z++)
                {
                    if (!chunk.blocks[x, y, z].changed)
                        continue;

                    WorldPos pos = new WorldPos(x, y, z);
                    blocks.Add(pos, chunk.blocks[x, y, z]);
                }
            }
        }
    }
}