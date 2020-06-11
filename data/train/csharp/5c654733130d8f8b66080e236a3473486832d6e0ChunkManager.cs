using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkManager : MonoBehaviour
{
    public GameObject StartingChunk;
    public List<GameObject> GroundChunkPrefabs;

    private float _leftMostChunkPos = 0;

    void Start()
    {
        ObjectPool.Pop(StartingChunk).GetComponent<Chunk>().Spawn(new Vector3(_leftMostChunkPos, -10, 1));
        _leftMostChunkPos += 40;
    }

    void Update()
    {
        if (CameraFollow.RightEdge + 25 >= _leftMostChunkPos)
        {
            SpawnChunk(GroundChunkPrefabs[Random.Range(0, GroundChunkPrefabs.Count)]);
        }
    }

    void SpawnChunk(GameObject chunkPrefab)
    {
        ObjectPool.Pop(chunkPrefab).GetComponent<Chunk>().Spawn(new Vector3(_leftMostChunkPos, -10, 1));
        _leftMostChunkPos += 40;
    }
}