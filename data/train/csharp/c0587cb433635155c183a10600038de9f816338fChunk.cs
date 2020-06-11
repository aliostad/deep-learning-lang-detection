using System;
using UnityEngine;

public class Chunk {
    public World w;

    private int chunkX, chunkY, chunkZ = 0;

    public const int chunkLogSize = 4;
    public const int chunkSize = 1 << chunkLogSize;
    public const int chunkMask = chunkSize - 1;
    private Block[,,] data = new Block[chunkSize, chunkSize, chunkSize];

    public Chunk(World w, int chunkX, int chunkY, int chunkZ) {
        this.w = w;
        this.chunkX = chunkX;
        this.chunkY = chunkY;
        this.chunkZ = chunkZ;

        for(int x = 0; x < chunkSize; x++) {
            for(int y = 0; y < chunkSize; y++) {
                for(int z = 0; z < chunkSize; z++) {
                    data[x, y, z] = Block.NewBlock(BlockType.STONE);
                }
            }
        }
    }

    public Block this[int x, int y, int z] {
        get {
            try {
                if(x < 0 || x > chunkSize - 1 || y < 0 || y > chunkSize - 1 || z < 0 || z > chunkSize - 1) {
                    return w[chunkX * chunkSize + x, chunkY * chunkSize + y, chunkZ * chunkSize + z];
                }

                return data[x, y, z];
            } catch(IndexOutOfRangeException) {
                return new NullBlock();
            }
        }
        set {
            data[x, y, z] = value;
        }
    }
}
