using System.Collections;
using UnityEngine;

public class ChunkGroup {
    public Chunk[,,] Chunks;

    public ChunkGroup(Chunk[,,] chunks) {
        Chunks = chunks;
    }

    public byte GetBlock(int x, int y, int z) {
        int chunkSize = GameData.World.Config.ChunkSize;
        
        XYZ chunkCoords = new XYZ((int)Mathf.Floor(x / chunkSize), 
                                  (int)Mathf.Floor(y / chunkSize), 
                                  (int)Mathf.Floor(z / chunkSize));
        
        Chunk chunk = Chunks[chunkCoords.X, chunkCoords.Y, chunkCoords.Z];

        if(chunk == null) return 0;

        return chunk.GetBlock(x % chunkSize, y % chunkSize, z % chunkSize);
    }
}
