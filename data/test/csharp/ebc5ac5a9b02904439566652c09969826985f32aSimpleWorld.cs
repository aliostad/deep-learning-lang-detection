using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SimpleWorld : MonoBehaviour
{
    public SimpleChunkTextureDictionary textureDict;

    public Dictionary<WorldPos, SimpleChunk> simpleChunks = new Dictionary<WorldPos, SimpleChunk>();
    public GameObject simpleChunkPrefab;

    public string worldName = "simple_world";

    public void CreateSimpleChunk(int x, int y, int z)
    {
        WorldPos worldPos = new WorldPos(x, y, z);

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newSimpleChunkObject = Instantiate(
                        simpleChunkPrefab, new Vector3(x, y, z),
                        Quaternion.Euler(Vector3.zero)
                    ) as GameObject;

        SimpleChunk newSimpleChunk = newSimpleChunkObject.GetComponent<SimpleChunk>();

        newSimpleChunk.pos = worldPos;
        newSimpleChunk.simpleWorld = this;

        //Add it to the chunks dictionary with the position as the key
        simpleChunks.Add(worldPos, newSimpleChunk);

        var terrainGen = new TerrainGen();
        newSimpleChunk = terrainGen.SimpleChunkGen(newSimpleChunk);
        if(newSimpleChunk.simpleChunkType == SimpleChunkType.Air) { newSimpleChunk.gameObject.SetActive(false); return; }
        newSimpleChunkObject.GetComponent<Renderer>().material.mainTexture = textureDict.textDict[newSimpleChunk.simpleChunkType];
    }

    public void DestroySimpleChunk(int x, int y, int z)
    {
        SimpleChunk simpleChunk = null;
        if (simpleChunks.TryGetValue(new WorldPos(x, y, z), out simpleChunk))
        {
            Object.Destroy(simpleChunk.gameObject);
            simpleChunks.Remove(new WorldPos(x, y, z));
        }
    }

    public SimpleChunk GetSimpleChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        float multiple = SimpleChunk.chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * SimpleChunk.chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * SimpleChunk.chunkSize;
        pos.z = Mathf.FloorToInt(z / multiple) * SimpleChunk.chunkSize;

        SimpleChunk containerSimpleChunk = null;

        simpleChunks.TryGetValue(pos, out containerSimpleChunk);

        return containerSimpleChunk;
    }

    //public Block GetBlock(int x, int y, int z)
    //{
    //    Chunk containerChunk = GetSimpleChunk(x, y, z);

    //    if (containerChunk != null)
    //    {
    //        Block block = containerChunk.GetBlock(
    //            x - containerChunk.pos.x,
    //            y - containerChunk.pos.y,
    //            z - containerChunk.pos.z);

    //        return block;
    //    }
    //    else
    //    {
    //        return new BlockAir();
    //    }

    //}

    //public void SetBlock(int x, int y, int z, Block block)
    //{
    //    Chunk chunk = GetChunk(x, y, z);

    //    if (chunk != null)
    //    {
    //        chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
    //        chunk.update = true;

    //        UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
    //        UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
    //        UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
    //        UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
    //        UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
    //        UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));

    //    }
    //}

    public void SetSimpleChunk(int x, int y, int z, SimpleChunk simpleChunkTemplate)
    {
        print("2");
        simpleChunks.Add(new WorldPos(x,y,z), simpleChunkTemplate);
    }

    void UpdateIfEqual(int value1, int value2, WorldPos pos)
    {
        if (value1 == value2)
        {
            SimpleChunk chunk = GetSimpleChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
                chunk.update = true;
        }
    }
}
