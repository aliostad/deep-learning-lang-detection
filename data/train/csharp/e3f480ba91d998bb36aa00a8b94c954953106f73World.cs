using UnityEngine;
using System.Collections.Generic;

public class World : MonoBehaviour {

    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();

    public GameObject chunkPrefab;

    public string worldName = "world";

    public int newChunkX;
    public int newChunkY;
    public int newChunkZ;

    public bool genChunk;

    // Use this for initialization
    void Start()
    {
        for (int x = -4; x < 4; x++)
        {
            for (int y = -1; y < 3; y++)
            {
                for (int z = -4; z < 4; z++)
                {
                    CreateChunk(x * 16, y * 16, z * 16);
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (genChunk)
        {
            genChunk = false;
            WorldPos chunkPos = new WorldPos(newChunkX, newChunkY, newChunkZ);
            Chunk chunk = null;

            if (chunks.TryGetValue(chunkPos, out chunk))
            {
                DestroyChunk(chunkPos.x, chunkPos.y, chunkPos.z);
            }
            else
            {
                CreateChunk(chunkPos.x, chunkPos.y, chunkPos.z);
            }
        }
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

        newChunk.WorldPosition = worldPos;
        newChunk.World = this;

        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);
        // REMOVE THIS
        //        for (int xi = 0; xi < 16; xi++)
        //        {
        //            for (int yi = 0; yi < 16; yi++)
        //            {
        //                for (int zi = 0; zi < 16; zi++)
        //                {
        //                    if (yi <= 7)
        //                    {
        //                        SetBlock(x + xi, y + yi, z + zi, new BlockGrass());
        //                    }
        //                    else
        //                    {
        //                        SetBlock(x + xi, y + yi, z + zi, new BlockAir());
        //                    }
        //                }
        //            }
        //        }
        //REMOVE ABOVE

        //Add these lines:
        var terrainGen = new TerrainGen();
        newChunk = terrainGen.ChunkGen(newChunk);

        newChunk.SetBlocksUnmodified();

        bool loaded = Serialization.Load(newChunk);

    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {
            Serialization.SaveChunk(chunk);    //Add this line to the function
            UnityEngine.Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y, z));
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
            x - containerChunk.WorldPosition.x,
            y - containerChunk.WorldPosition.y,
            z - containerChunk.WorldPosition.z);

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
            chunk.SetBlock(x - chunk.WorldPosition.x, y - chunk.WorldPosition.y, z - chunk.WorldPosition.z, block);
            chunk.update = true;

            UpdateIfEqual(x - chunk.WorldPosition.x, 0, new WorldPos(x - 1, y, z));
            UpdateIfEqual(x - chunk.WorldPosition.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
            UpdateIfEqual(y - chunk.WorldPosition.y, 0, new WorldPos(x, y - 1, z));
            UpdateIfEqual(y - chunk.WorldPosition.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
            UpdateIfEqual(z - chunk.WorldPosition.z, 0, new WorldPos(x, y, z - 1));
            UpdateIfEqual(z - chunk.WorldPosition.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
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
}
