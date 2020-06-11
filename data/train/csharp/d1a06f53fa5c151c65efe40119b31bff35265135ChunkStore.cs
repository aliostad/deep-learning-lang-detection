using UnityEngine;
using System.Linq;
using System;
using System.Collections;
using System.Collections.Generic;

public class ChunkStore
{
    public ChunkStore(IChunkGenerator generator, Material material, Transform parentTransform)
    {
        this.material = material;
        this.parentTransform = parentTransform;
        this.generator = generator;
    }
    
    public const int MaxChunks = 512;
    
    Transform parentTransform;
    Material material;
    Dictionary<int, Chunk> chunks = new Dictionary<int, Chunk>();
    IChunkGenerator generator;

    public int Mass { get { return chunks.Values.Sum(chunk => chunk.Mass); } }

    static int PositionHash(int x, int y, int z, out int cx, out int cy, out int cz)
    {
        cx = x >= 0 ? x / Chunk.BlockSize : (x - Chunk.BlockSize + 1) / Chunk.BlockSize; 
        cy = y >= 0 ? y / Chunk.BlockSize : (y - Chunk.BlockSize + 1) / Chunk.BlockSize; 
        cz = z >= 0 ? z / Chunk.BlockSize : (z - Chunk.BlockSize + 1) / Chunk.BlockSize;
        return ((cx - MaxChunks / 2) * MaxChunks * MaxChunks) + ((cy - MaxChunks / 2) * MaxChunks) + (cz - MaxChunks / 2);
    }
    
    public Chunk Get(int x, int y, int z)
    {
        int cx, cy, cz;
        int hash = PositionHash(x, y, z, out cx, out cy, out cz);

        //Debug.Log ("(" + x + " " + y + " " + z + ") -> " + cx + " " + cy + " " + cz + " -> " + hash);
        Chunk chunk;
        if (chunks.TryGetValue(hash, out chunk))
            return chunk;
        else
            return null;
    }
    
    public Chunk Add(int x, int y, int z)
    {
        if (Get(x, y, z) == null)
        {
            int cx, cy, cz;
            int hash = PositionHash(x, y, z, out cx, out cy, out cz);

            Chunk chunk = (Chunk)new GameObject("Chunk").AddComponent<Chunk>();
            chunk.transform.parent = parentTransform;
            chunk.transform.localPosition = Vector3.zero;
            chunk.transform.localRotation = Quaternion.identity;
            chunk.renderer.sharedMaterial = material;
            chunk.ChunkPos = new Point3D(cx, cy, cz);
            chunk.Generate(generator);
            chunks.Add(hash, chunk);
            return chunk;
        }
        else
        {
            return Get(x, y, z);
        }
    }
}
