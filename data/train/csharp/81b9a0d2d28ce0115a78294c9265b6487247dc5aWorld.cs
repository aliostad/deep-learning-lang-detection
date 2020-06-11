using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour
{

    public GameObject chunkPrefab;

    public List<Chunk> spawnedChunkList;
    public SaveLoad saveLoadManager;


    private void Awake()
    {
        spawnedChunkList = new List<Chunk>();
        saveLoadManager = GameObject.Find("Game").GetComponent<SaveLoad>();
    }

    public void CreateNew()
    {
        spawnedChunkList = new List<Chunk>();
        for (int x = -1; x <= 1; x++)
        {
            for (int y = -1; y <= 1; y++)
            {
                Chunk chunk = Instantiate(chunkPrefab).GetComponent<Chunk>();
                chunk.CreateNew(x, y);
                chunk.transform.parent = this.transform;
                spawnedChunkList.Add(chunk);
            }
        }

        Debug.Log("new world created");
    }

    public void Repopulate(int xOffset, int yOffset)
    {
        for (int x = xOffset - 1; x <= xOffset + 1; x++)
        {
            for (int y = yOffset - 1; y <= yOffset + 1; y++)
            {
                if (!ChunkIsAlreadyInWorld("Chunk " + x + " " + y))
                {
                    Chunk newChunk = Instantiate(chunkPrefab).GetComponent<Chunk>();
                    newChunk.name = "Chunk " + x + " " + y;
                    newChunk.transform.parent = this.transform;
                    spawnedChunkList.Add(newChunk);
                    newChunk.xOffset = x;
                    newChunk.yOffset = y;

                    if (saveLoadManager.Exists(newChunk))
                    {
                        Debug.Log("chunk is not spawned, but can be loaded");
                        saveLoadManager.Load(newChunk);
                    }
                    else
                    {
                        Debug.Log("chunk is not exists, creating new");
                        newChunk.CreateNew(x, y);
                    }
                }
            }
        }

        Debug.Log("world repopulated");
    }

    public bool ChunkIsAlreadyInWorld(string name)
    {
        bool chunkIsInList = false;
        foreach (Chunk spawnedChunk in spawnedChunkList)
        {
            if (spawnedChunk.name == name)
            {
                chunkIsInList = true;
                Debug.Log("chunk already spawned");
            }
        }
        return chunkIsInList;
    }
}
