using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour
{
    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();

    //Chunk[, ,] worldChunks;

    public WorldPos PlayerPos;
    public GameObject Player;
    public GameObject chunkPrefab;

    //public bool genChunk;

    //const int SIZE = 4086;
    //const int HALF = SIZE / 2;
    const int YSTART = -1;
    const int YEND = 3;

    int newX = 0;
    int newY = 0;
    int newZ = 0;

    void Start()
    {
        //worldChunks = new Chunk[SIZE, 4, SIZE];

        Player = GameObject.Find("Player");
        PlayerPos = GetPlayerPos();

        // triple for-loop to generate series of Chunks around the player's position
        for(int x = -(Chunk.chunkSize / 2); x < Chunk.chunkSize / 2; x++)
        {
            for(int z = -(Chunk.chunkSize / 2); z < Chunk.chunkSize / 2; z++)
            {
                for(int y = YSTART; y < YEND; y++)
                {
                    newX = (PlayerPos.x + x) * Chunk.chunkSize;
                    newY = (PlayerPos.y + y) * Chunk.chunkSize;
                    newZ = (PlayerPos.z + z) * Chunk.chunkSize;

                    CreateChunk(newX, newY, newZ);
                }
            }
        }
    }

    void Update()
    {
        WorldPos CurrPos = GetPlayerPos();

        if (CurrPos.z >= PlayerPos.z + (Chunk.chunkSize))
            MoveZPlus();
        //if (CurrPos.z < PlayerPos.z - (Chunk.chunkSize))
        //    MoveZMinus();
        if (CurrPos.x >= PlayerPos.x + (Chunk.chunkSize))
            MoveXPlus();
        if (CurrPos.x < PlayerPos.x - (Chunk.chunkSize))
            MoveXMinus();

        //Debug.Log(PlayerPos.x + ", " + PlayerPos.y + ", " + PlayerPos.z);
    }

    void MoveZPlus()
    {
        PlayerPos = GetPlayerPos();

        for (int x = -(Chunk.chunkSize / 2); x < Chunk.chunkSize / 2; x++)
        {
            for (int y = YSTART; y < YEND; y++)
            {
                newX = PlayerPos.x + (x * Chunk.chunkSize);
                newY = y * Chunk.chunkSize;
                newZ = PlayerPos.z + Chunk.chunkSize * (Chunk.chunkSize / 2) - Chunk.chunkSize;

                CreateChunk(newX, newY, newZ);

                if (x == -(Chunk.chunkSize / 2))
                {
                    while (PlayerPos.x % Chunk.chunkSize != 0)
                        PlayerPos.x--;
                    while (PlayerPos.z % Chunk.chunkSize != 0)
                        PlayerPos.z++;

                    Debug.Log("PlayerPos: " + PlayerPos.x + " " + PlayerPos.z);

                    for (int d = x; d < Chunk.chunkSize / 2; d++)
                    {
                        DestroyChunk(
                            PlayerPos.x + (d * Chunk.chunkSize),
                            newY,
                            PlayerPos.z - Chunk.chunkSize * (Chunk.chunkSize / 2) - Chunk.chunkSize
                            );
                    }
                }
            }
        }
    }

    void MoveXPlus()
    {
        PlayerPos = GetPlayerPos();

        for (int z = -(Chunk.chunkSize / 2); z < Chunk.chunkSize / 2; z++)
        {
            for (int y = YSTART; y < YEND; y++)
            {
                newX = PlayerPos.x + Chunk.chunkSize * (Chunk.chunkSize / 2) - Chunk.chunkSize;
                newY = y * Chunk.chunkSize;
                newZ = PlayerPos.z + (z * Chunk.chunkSize);

                CreateChunk(newX, newY, newZ);

                if (z == -(Chunk.chunkSize / 2))
                {
                    while (PlayerPos.z % Chunk.chunkSize != 0)
                        PlayerPos.z--;
                    while (PlayerPos.x % Chunk.chunkSize != 0)
                        PlayerPos.x++;

                    Debug.Log("PlayerPos: " + PlayerPos.x + " " + PlayerPos.z);

                    for (int d = z; d < Chunk.chunkSize / 2; d++)
                    {
                        DestroyChunk(
                            PlayerPos.x - Chunk.chunkSize * (Chunk.chunkSize / 2) - Chunk.chunkSize,
                            newY,
                            PlayerPos.z + (d * Chunk.chunkSize)
                            );
                    }
                }
            }
        }
    }

    void MoveXMinus()
    {
        PlayerPos = GetPlayerPos();

        for(int z = -(Chunk.chunkSize / 2); z < Chunk.chunkSize / 2; z++)
        {
            for(int y = YSTART; y < YEND; y++)
            {
                newX = PlayerPos.x - Chunk.chunkSize * (Chunk.chunkSize / 2) + Chunk.chunkSize;
                newY = y * Chunk.chunkSize;
                newZ = PlayerPos.z + (z * Chunk.chunkSize);

                CreateChunk(newX, newY, newZ);
                 
                if(z == (Chunk.chunkSize / 2) - 1)
                {
                    while (PlayerPos.x % 16 != 0)
                        PlayerPos.x++;

                    for(int d = -(Chunk.chunkSize / 2); d <= z; d++)
                    {
                        DestroyChunk(
                            PlayerPos.x + Chunk.chunkSize * (Chunk.chunkSize / 2),
                            newY,
                            PlayerPos.z + (d * Chunk.chunkSize)
                            );
                    }
                }
            }
        }
    }

    WorldPos ConvertCameraPosition()
    {
        Vector3 camPos = Camera.main.transform.position;
        return new WorldPos((int)Mathf.Round(camPos.x / Chunk.chunkSize) * Chunk.chunkSize,
                            (int)Mathf.Round(camPos.y / Chunk.chunkSize) * Chunk.chunkSize,
                            (int)Mathf.Round(camPos.z / Chunk.chunkSize) * Chunk.chunkSize);
    }

    WorldPos GetPlayerPos()
    {
        // returns player position wherever in the game
        return new WorldPos((int)Player.transform.position.x,
                            0,
                            (int)Player.transform.position.z);
    }

    WorldPos GetPotentialStartPosition()
    {
        return GetPlayerPos();
    }

    public Chunk CreateChunk(int x, int y, int z)
    {
        //if (y == 0)
        //    Debug.Log("create " + x + ", 0, " + z);

        // assign a new world position with the values passed
        WorldPos worldPos = new WorldPos(x, y, z);

        // Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(x, y, z), Quaternion.Euler(Vector3.zero)) as GameObject;

        // assigns the instantiated chunk to newChunk
        Chunk newChunk = newChunkObject.GetComponent<Chunk>();

        newChunk.pos = worldPos;
        newChunk.world = this;

        // Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);

        var terrainGen = new TerrainGen();
        newChunk = terrainGen.ChunkGen(newChunk);

        //newChunk.SetBlocksUnmodified();

        return newChunk;
    }

    public Chunk DestroyChunk(int x, int y, int z)
    {
        Chunk c = GetChunk(x, y, z);

        //if (y == 0)
        //    Debug.Log("Destroy: " + x + ", " + y + ", " + z);

        Chunk chunk = null;
        if(chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {
            UnityEngine.Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y, z));
            //worldChunks[i, j, k] = null;

            return null;
        }

        return c;
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

        if(containerChunk != null)
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

    void UpdateIfEqual(int value1, int value2, WorldPos pos)
    {
        if(value1 == value2)
        {
            Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
                chunk.update = true;
        }
    }
}