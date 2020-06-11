using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour {

    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();

    public GameObject chunkPrefab;

    // Use this for initialization
    public void InitData ()
    {
        for (int x = -2; x <= 1; x++)
        {
            for (int y = 0; y <= 1; y++)
            {
                for (int z = -2; z <= 1; z++)
                {
                    CreateChunk(x * 16, y * 16, z * 16);
                }
            }
        }
    }

    public void CreateChunk(int x, int y, int z)
    {
        WorldPos worldPos = new WorldPos(x, y, z);

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(x, y, z), Quaternion.Euler(Vector3.zero)) as GameObject;
        newChunkObject.transform.parent = transform;

        Chunk newChunk = newChunkObject.GetComponent<Chunk>();

        newChunk.pos = worldPos;
        newChunk.world = this;

        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);

        for (int xi = 0; xi < 16; xi++)
        {
            for (int yi = 0; yi < 16; yi++)
            {
                for (int zi = 0; zi < 16; zi++)
                {
                    SetBlock(x + xi, y + yi, z + zi, new BlockAir());
                }
            }
        }
    }

    public void UpdateChucks()
    {
        float[,] mapHeight = References.Refs.mapGenerator.GenerateNoiseMap();

        for (int x = -32; x < 32; x++)
        {
            for (int z = -32; z < 32; z++)
            {
                for (int y = 0; y < 32; y++)
                {
                    int Height = Mathf.RoundToInt(mapHeight[x + 32, z + 32] * 32);

                    if(Height >= 6 && Height <= 13)
                    {
                        SetBlock(x, Height, z, new BlockStone());
                    }
                    else if (Height > 13)
                    {
                        SetBlock(x, Height, z, new BlockSnow());
                    }
                    else
                    {
                        SetBlock(x, Height, z, new BlockGrass());
                    }

                    if (y < Height)
                    {
                        if (y > 7 && y <= 13)
                        {
                            SetBlock(x, y, z, new BlockStone());
                        }
                        else if (y > 13)
                        {
                            SetBlock(x, y, z, new BlockSnow());
                        }
                        else
                        {
                            SetBlock(x, y, z, new BlockStone());
                        }
                    }
                }
            }
        }

        for (int xi = -2; xi <= 1; xi++)
        {
            for (int zi = -2; zi <= 1; zi++)
            {
                Chunk containerChunk = GetChunk(xi * 16, 0, zi * 16);
                if (containerChunk != null)
                {
                    containerChunk.update = true;
                }
            }
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
            chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
        }
    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {
            Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y, z));
        }
    }
}
