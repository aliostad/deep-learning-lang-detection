using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {

    public Dictionary<WorldPosition, Chunk> chunks = new Dictionary<WorldPosition, Chunk>();
    public GameObject chunkPrefab;

    public void CreateChunk(int x, int y, int z)
    {
        WorldPosition worldPos = new WorldPosition(x, y, z);

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(
                        chunkPrefab, 
                        new Vector3(x, y, z),
                        Quaternion.Euler(Vector3.zero)
                    ) as GameObject;

        Chunk newChunk = newChunkObject.GetComponent<Chunk>();
        newChunkObject.transform.parent = transform;

        newChunk.worldPosition = worldPos;
        newChunk.world = this;

        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);

        var terrainGen = new TerrainGen();
        newChunk = terrainGen.ChunkGen(newChunk);
        newChunk.SetBlocksUnmodified();
    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPosition(x, y, z), out chunk))
        {
            Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPosition(x, y, z));
        }
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPosition pos = new WorldPosition();
        float multiple = Chunk.chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize;
        pos.z = Mathf.FloorToInt(z / multiple) * Chunk.chunkSize;

        Chunk containerChunk = null;

        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }

    public Block GetBlock(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y, z);

        if (containerChunk != null)
        {
            Block block = containerChunk.GetBlock(
                x - containerChunk.worldPosition.x,
                y - containerChunk.worldPosition.y,
                z - containerChunk.worldPosition.z);

            return block;
        }
        else
        {
            return new BlockAir();
        }

    }

    public void SetBlock(int x, int y, int z, Block block)
    {
        Chunk chunk = GetChunk(x, y, z);

        if (chunk != null)
        {
            chunk.SetBlock(x - chunk.worldPosition.x, y - chunk.worldPosition.y, z - chunk.worldPosition.z, block);
            chunk.update = true;

            UpdateIfEqual(x - chunk.worldPosition.x, 0, new WorldPosition(x - 1, y, z));
            UpdateIfEqual(x - chunk.worldPosition.x, Chunk.chunkSize - 1, new WorldPosition(x + 1, y, z));
            UpdateIfEqual(y - chunk.worldPosition.y, 0, new WorldPosition(x, y - 1, z));
            UpdateIfEqual(y - chunk.worldPosition.y, Chunk.chunkSize - 1, new WorldPosition(x, y + 1, z));
            UpdateIfEqual(z - chunk.worldPosition.z, 0, new WorldPosition(x, y, z - 1));
            UpdateIfEqual(z - chunk.worldPosition.z, Chunk.chunkSize - 1, new WorldPosition(x, y, z + 1));
        
        }
    }

    void UpdateIfEqual(int value1, int value2, WorldPosition pos)
    {
        if (value1 == value2)
        {
            Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
                chunk.update = true;
        }
    }
}
