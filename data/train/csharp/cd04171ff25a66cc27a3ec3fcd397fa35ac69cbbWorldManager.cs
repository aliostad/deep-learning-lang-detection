/* WorldManager.cs  
 * (c) 2017 Ritoban Roy-Chowdhury. All rights reserved 
 */

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldManager : MonoBehaviour
{
    public GameObject ChunkPrefab;

    public Dictionary<WorldPos, Chunk> worldPosChunkMap = new Dictionary<WorldPos, Chunk>();

    // FIXME: Hardcoding! Create a voxel data registry
    public VoxelData StoneVoxel;
    public VoxelData AirVoxel;

    int numChunks = 8;

    #region Unity Methods
    // ALERT: We are going only 1 up in the y axis
    private void Start()
    {
        // Create some chunks (2x1x2 = 4 chunks)
        for (int x = 0; x < numChunks; x++)
        {
            for (int y = 0; y < 1; y++)
            {
                for (int z = 0; z < numChunks; z++)
                {
                    CreateChunk(x * Chunk.CHUNK_SIZE, y * Chunk.CHUNK_SIZE, z * Chunk.CHUNK_SIZE);
                }
            }
        }

    }

    //HashSet<Chunk> toUpdate = new HashSet<Chunk>();


    //private void Update()
    //{
    //    foreach (Chunk c in toUpdate)
    //    {
    //        c.CalculateMeshData();
    //        c.RenderChunk();
    //    }
    //    toUpdate.Clear();
    //}


    #endregion

    /// <summary>
    /// Creates a chunk given a position
    /// </summary>
    /// <param name="x">The x coordinate of the chunk in world space. The number of blocks before this, not the chunk index</param>
    /// <param name="y">The y coordinate of the chunk in world space. The number of blocks before this, not the chunk index</param>
    /// <param name="z">The z coordinate of the chunk in world space. The number of blocks before this, not the chunk index</param>
    public void CreateChunk(int x, int y, int z)
    {
        GameObject chunkObj = Instantiate(
                ChunkPrefab,
                new Vector3(x, y, z),
                Quaternion.identity,
                this.transform
                )
                as GameObject;
        chunkObj.name = "Chunk " + x/Chunk.CHUNK_SIZE + " " + y/Chunk.CHUNK_SIZE + " " + z/Chunk.CHUNK_SIZE;
        Chunk chunk = new Chunk(
            this,
            chunkObj,
            new WorldPos(x, y, z)
            );
        worldPosChunkMap.Add(new WorldPos(x, y, z), chunk);

        for (int xi = 0; xi < Chunk.CHUNK_SIZE; xi++)
        {
            for (int yi = 0; yi < Chunk.CHUNK_SIZE; yi++)
            {
                for (int zi = 0; zi < Chunk.CHUNK_SIZE; zi++)
                {
                    if (yi <=
                        Mathf.PerlinNoise(
                            (float)(xi + x) / (Chunk.CHUNK_SIZE) * 0.3f + (float)Network.time / 4f,
                            (float)(zi + z) / (Chunk.CHUNK_SIZE) * 0.3f + (float)Network.time / 4f)
                        * Chunk.CHUNK_SIZE
                        )
                        SetVoxel(x + xi, y + yi, z + zi, new Voxel(xi, yi, zi, chunk, StoneVoxel));
                    else
                        SetVoxel(x + xi, y + yi, z + zi, new Voxel(x, y, z, chunk, AirVoxel));
                }
            }
        }

        chunk.CalculateMeshData();
        chunk.RenderChunk();

    }

    #region Utility Methods
    /// <summary>
    /// Gets a chunk given a coordinate of a block in the chunk. (Chunk index * CHUNK_SIZE)
    /// </summary>
    /// <param name="x">The x coordinate of the block</param>
    /// <param name="y">The y coordinate of the block</param>
    /// <param name="z">The z coordinate of the block</param>
    public Chunk GetChunk(int x, int y, int z)
    {
        // Creating an empty worldPos
        WorldPos pos = new WorldPos();
        // Casting it to a float
        float chunkSize = Chunk.CHUNK_SIZE;
        // Take out any remainder after dividing it by chunkSize. Effectively getting the 0,0 coordinate in the chunk
        pos.X = Mathf.FloorToInt(x / chunkSize) * Chunk.CHUNK_SIZE;
        pos.Y = Mathf.FloorToInt(y / chunkSize) * Chunk.CHUNK_SIZE;
        pos.Z = Mathf.FloorToInt(z / chunkSize) * Chunk.CHUNK_SIZE;
        Chunk containerChunk = null;
        worldPosChunkMap.TryGetValue(pos, out containerChunk);
        return containerChunk;
    }

    public Voxel GetVoxel(int x, int y, int z)
    {
        Chunk chunk = GetChunk(x, y, z);
        if (chunk == null)  
            // HACK. We are off the edge, so we are just returning an empty air voxel. 
            //         This probably will cause problems, but its fine for now. 
            //         After all, you do expect nothingness if you fall off the edge of the earth!
            return new Voxel(x, y, z, null, AirVoxel);

        // FIXME: Converting the voxel from world space to chunk space. In practice, 
        //          we should overload the worldPos subtraction operator or create a conversion function
        Voxel voxel = chunk.GetVoxel(x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z);
        return voxel;

    }

    public void SetVoxel(int x, int y, int z, Voxel voxel)
    {
        Chunk chunk = GetChunk(x, y, z);
        if (chunk != null)
        {
            chunk.SetVoxel(x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z, voxel);
        }
    }
    #endregion
}
