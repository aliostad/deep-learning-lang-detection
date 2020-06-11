using UnityEngine;
using System.Collections;

public class StaticTerrainGen : TerrainGen {

    public StaticTerrainGen() : base(0) {

    }

    public override Chunk ChunkGen(Chunk chunk) {
        if (chunk.pos.y >= 16 || chunk.pos.y < 0)
            return null;
        for (int x = chunk.pos.x; x < chunk.pos.x + Chunk.chunkSize; x++) {
            for (int z = chunk.pos.z; z < chunk.pos.z + Chunk.chunkSize; z++) {
                ChunkColumnGen(chunk, x, z);
            }
        }
        return chunk;
    }

    public override void ChunkColumnGen(Chunk chunk, int x, int z) {
        for (int y = chunk.pos.y; y < chunk.pos.y + Chunk.chunkSize; y++) {
            if (y <= 0)
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockGrass());
            else
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockAir());
        }
    }
}
