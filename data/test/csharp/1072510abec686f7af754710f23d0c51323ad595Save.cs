using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ASTutorial
{
    [Serializable]
    public class Save
    {
        public Dictionary<WorldPos, Block> blocks = new Dictionary<WorldPos, Block>();

        public Save(Chunk chunk)
        {
            for (int x = 0; x < Chunk.chunkSize; x++)
            {
                for (int y = 0; y < Chunk.chunkSize; y++)
                {
                    for (int z = 0; z < Chunk.chunkSize; z++)
                    {
                        if(!chunk.blocks[x,y,z].changed)
                        {
                            continue;
                        }

                        WorldPos pos = new WorldPos(x, y, z);
                        blocks.Add(pos, chunk.blocks[x, y, z]);
                    }
                }
            }
        }
    }
}