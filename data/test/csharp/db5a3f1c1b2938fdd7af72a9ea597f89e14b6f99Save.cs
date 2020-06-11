using System;
using System.Collections.Generic;

[Serializable]
public class Save {

    public Dictionary<WorldPosition, Block> blockDictionary = new Dictionary<WorldPosition, Block>();

    public Save(Chunk chunk)
    {
        for (int x = 0; x < Chunk.chunkSize; x++)
        {
            for (int y = 0; y < Chunk.chunkHeight; y++)
            {
                for (int z = 0; z < Chunk.chunkSize; z++)
                {
                    WorldPosition position = new WorldPosition(x, y, z);
                    blockDictionary.Add(position, chunk.blockArray[x, y, z]);
                }
            }
        }
    }
}
