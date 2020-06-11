using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour {

    public static World WorldInstance;

    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
    public GameObject chunkPrefab;
    public string worldName = "world";

    void Awake()
    {
        Application.targetFrameRate = 90;
    }

    // Use this for initialization
    void Start()
    {
        WorldInstance = this;
        for (int x = -6; x < 6; x++)
        {
            for (int y = -1; y < 4; y++)
            {
                for (int z = -6; z < 6; z++)
                {
                    CreateChunk(x * Chunk.chunkSize, y * Chunk.chunkSize, z * Chunk.chunkSize);
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void CreateChunk(int x, int y, int z)
    {
        WorldPos worldPos = new WorldPos(x, y, z);

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(
                        chunkPrefab, new Vector3(x, y, z),
                        Quaternion.Euler(Vector3.zero)
                    ) as GameObject;

        Chunk newChunk = newChunkObject.GetComponent<Chunk>();

        newChunk.pos = worldPos;
        newChunk.world = this;

        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);

        if (Serialization.Load(newChunk)) return;
        else
        {
            var terrainGen = new TerrainGen();
            newChunk = terrainGen.ChunkGen(newChunk);
        }
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
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
                x - containerChunk.pos.x,
                y - containerChunk.pos.y,
                z - containerChunk.pos.z);

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
            if (block.type == chunk.GetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z).type) return;
            chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
            chunk.update = true;

            UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
            UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
            UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
            UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
            UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
            UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
        }
    }
    public void SetBlock(Vector3 pos, Block block)
    {
        SetBlock(Mathf.RoundToInt(pos.x), Mathf.RoundToInt(pos.y), Mathf.RoundToInt(pos.z), block);
    }
    private void DamageBlock(int x, int y, int z, int damage)
    {
        Chunk chunk = GetChunk(x, y, z);

        if (chunk != null)
        {
            Block block = chunk.GetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z);
            if (block.health <= 0) return;
            else block.health -= damage;

            if (block.health <= 0)
            {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockAir());
                chunk.update = true;

                UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
                UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
                UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
                UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
                UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
                UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
            }
        }
    }
    private void DamageBlock(Vector3 pos, int damage)
    {
        DamageBlock(Mathf.RoundToInt(pos.x), Mathf.RoundToInt(pos.y), Mathf.RoundToInt(pos.z), damage);
    }
    
    public void DamageBlocks(Vector3 startingpos, int explosionsize, int damage)
    {
        for (int x = -explosionsize; x <= explosionsize; ++x)
        {
            for (int y = -explosionsize; y <= explosionsize; ++y)
            {
                for (int z = -explosionsize; z <= explosionsize; ++z)
                {
                    float distance = Mathf.Sqrt(x * x + y * y + z * z);
                    int newdamage = damage / (Mathf.FloorToInt(distance + 1.5f));
                    DamageBlock(startingpos + new Vector3(x, y, z), newdamage);
                }
            }
        }
    }


    void UpdateIfEqual(int value1, int value2, WorldPos pos)
    {
        if (value1 == value2)
        {
            Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
                chunk.update = true;
        }
    }

    private void OnApplicationQuit()
    {
        foreach(KeyValuePair<WorldPos, Chunk> c in chunks)
        {
            //Serialization.SaveChunk(c.Value);
        }
    }
}
