using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {

    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
    public GameObject chunkPrefab;
    public GameObject treePrefab;
    public GameObject bonePrefab;
    public GameObject horsePrefab;
    public GameObject huckPrefab;
    public GameObject waterPrefab;


    public string worldName = "world";

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

        var terrainGen = new TerrainGen();
        newChunk = terrainGen.ChunkGen(newChunk);
        if (newChunk.airCount == 6144) { newChunk.gameObject.SetActive(false); }
        newChunk.SetBlocksUnmodified();

        for (int i = 0; i < newChunk.treeList.Count; i++)
        {
            GameObject newTree = Instantiate(treePrefab);
            newTree.transform.position = newChunk.treeList[i];
        }
        for (int i = 0; i < newChunk.bushList.Count; i++)
        {
            GameObject newBush = Instantiate(huckPrefab);
            newBush.transform.position = newChunk.bushList[i];
        }
        if (newChunk.boneSpawn)
        {
            print("boneSpawn");
            GameObject newBone = Instantiate(bonePrefab);
            newBone.transform.position = newChunk.boneList[0];
        }
        if (newChunk.horseSpawn)
        {
            print("boneSpawn");
            GameObject newHorse = Instantiate(horsePrefab);
            newHorse.transform.position = newChunk.horseList[0];
        }
        Serialization.Load(newChunk);
        if (newChunk.hasWater)
        {
            GameObject newWater = Instantiate(waterPrefab);
            newWater.transform.position = newChunk.transform.position;
            newChunk.water = newWater;
            newChunk.chunkWater = newWater.GetComponent<ChunkWater>();
        }
    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {
            Serialization.SaveChunk(chunk);
            Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y, z));
        }
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        //float multiple = 4;
        pos.x = Mathf.FloorToInt(x / 4f) * 4;
        pos.y = Mathf.FloorToInt(y / 4f) * 4;
        pos.z = Mathf.FloorToInt(z / 4f) * 4;

        Chunk containerChunk = null;

        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }

    public Block GetBlock(float x, float y, float z)
    {
        Chunk containerChunk = GetChunk(Mathf.FloorToInt(x), Mathf.FloorToInt(y), Mathf.FloorToInt(z));

        if (containerChunk != null)
        {
            Block block = containerChunk.GetBlock(
                (int)(4 * (x - containerChunk.pos.x)),
                (int)(4 * (y - containerChunk.pos.y)),
                (int)(4 * (z - containerChunk.pos.z)));

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
        if (value1 == value2)
        {
            Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
                chunk.update = true;
        }
    }

    void CreateTree(int x, int y, int z)
    {
        GameObject newTree = Instantiate(treePrefab);
        newTree.transform.position = new Vector3(x, y, z);
    }
}
