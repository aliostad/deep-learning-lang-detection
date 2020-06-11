using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour
{
    public string worldName = "world";

    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
    public GameObject chunkPrefab;

    public int newChunkX;
    public int newChunkY;

    public bool genChunk;

    void Start()
    {
        for (int x = -4; x < 4; x++)
        {
            for (int y = -1; y < 3; y++)
            {
                CreateChunk(x * 16, y * 16);
            }
        }
    }

    void Update()
    {
        if (genChunk)
        {
            genChunk = false;
            WorldPos chunkPos = new WorldPos(newChunkX, newChunkY);
            Chunk chunk = null;

            if (chunks.TryGetValue(chunkPos, out chunk))
            {
                DestroyChunk(chunkPos.x, chunkPos.y);
            }
            else
            {
                CreateChunk(chunkPos.x, chunkPos.y);
            }
        }
    }

    public Chunk GetChunk(int x, int y)
    {
        WorldPos pos = new WorldPos();
        float multiple = Chunk.chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize;
        Chunk containerChunk = null;
        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }
    public Block GetBlock(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y);
        if (containerChunk != null)
        {
            Block block = containerChunk.GetBlock(x - containerChunk.pos.x, y - containerChunk.pos.y, z);

            return block;
        }
        else
        {
            return new BlockAir();
        }
    }

    public void SetBlock(int x, int y, int z, Block block)
    {
        Chunk chunk = GetChunk(x, y);

        if (chunk != null)
        {
            chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z, block);
            chunk.update = true;

            UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y));
            UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y));
            UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1));
            UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1));
        }
    }

    public void CreateChunk(int x, int y)
    {
        WorldPos worldPos = new WorldPos(x, y);
        GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(x, y), Quaternion.Euler(Vector3.zero)) as GameObject;
        Chunk newChunk = newChunkObject.GetComponent<Chunk>();
        newChunk.pos = worldPos;
        newChunk.world = this;

        chunks.Add(worldPos, newChunk);

        var terrainGen = new TerrainGen();
        newChunk = terrainGen.ChunkGen(newChunk);
        newChunk.SetBlocksUnmodified();
        bool loaded = Serialization.Load(newChunk);
    }

    public void DestroyChunk(int x, int y)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y), out chunk))
        {
            Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y));
        }
    }

    void UpdateIfEqual(int value1, int value2, WorldPos pos)
    {
        if (value1 == value2)
        {
            Chunk chunk = GetChunk(pos.x, pos.y);
            if (chunk != null)
                chunk.update = true;
        }
    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y), out chunk))
        {
            Serialization.SaveChunk(chunk);    //Add this line to the function
            UnityEngine.Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y));
        }
    }
}
