using UnityEngine;
using System.Collections;
using SimplexNoise;

public class TerrainGen {

    private float peakDistance = .01f;
    private static Perlin perlin = new Perlin();

    public TerrainGen(int seed) {
//        Random.seed = seed;
//        shuffle(Noise.perm);
    }

    private void shuffle(byte[] perm) {
        for (int t = 0; t < perm.Length / 2; t++) {
            byte tmp = perm[t];
            int r = Random.Range(t, perm.Length / 2);
            perm[t] = perm[r];
            perm[t + 256] = perm[r + 256];
            perm[r] = tmp;
            perm[r + 256] = tmp;
        }
    }

    public virtual Chunk ChunkGen(Chunk chunk) {
        for (int x = chunk.pos.x; x < chunk.pos.x + Chunk.chunkSize; x++) {
            for (int z = chunk.pos.z; z < chunk.pos.z + Chunk.chunkSize; z++) {
                ChunkColumnGen(chunk, x, z);
            }
        }
        return chunk;
    }
    int print = 0;
    public virtual void ChunkColumnGen(Chunk chunk, int x, int z) {
//        height += GetNoise(x, 0, z, peakDistance, maxHeight);
        for (int y = chunk.pos.y; y < chunk.pos.y + Chunk.chunkSize; y++) {
            double height = GetNoise(x, y, z, peakDistance, World.maxHeight) + y;
//            height += GetNoise(x, y, z, .05f, World.maxHeight) + y;
//            height /= 2;
            if (height < 1 && height > -1 && print < 10) {
                Debug.Log(height);
                print++;
            }
            if (height > 0) {
                if (y < 0)
                    chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockGrass());
                else
                    chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockAir());
            } else {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new Block());
            }
            
        }
    }
    
    public static float GetNoise(int x, int y, int z, float scale, int max) {
//        return Mathf.FloorToInt((float)(perlin.perlin(x * scale, y * scale, z * scale)));
        return (Noise.Generate(x * scale, y * scale * 2, z * scale) - .5f) * (max / 2f);
    }
}
