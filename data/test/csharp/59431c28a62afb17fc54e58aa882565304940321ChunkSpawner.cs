using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkSpawner : MonoBehaviour
{
    [SerializeField] private GameObject _beginnerChunk;
    private Queue<Chunk> _spawnedChunks;
    private UnityEngine.Object[] _possibleChunks;
    private Chunk _lastChunk;

    private Transform _playerPosition;
    int _lastChunkIndex = -1;

    private const float InitialSpawnX = -10;
    
    private void Start()
    {
        _spawnedChunks = new Queue<Chunk>();
        _possibleChunks = Resources.LoadAll("Chunks/");
        _playerPosition = GameObject.FindGameObjectWithTag("Player").transform;

        if (_beginnerChunk != null) InstantiateChunk(_beginnerChunk);
        for (var i = 0; i < 5; i++)
        {
            SpawnChunk();
        }
    }

    private void Update()
    {
        if (CheckDeleteChunk())
        {
            DeleteFirstChunk();
            SpawnChunk();
        }
    }
    

    private bool CheckDeleteChunk()
    {
        if (_spawnedChunks.Count == 0 || _playerPosition == null) return false;

        var chunk = _spawnedChunks.Peek();
        float deletepos = chunk.transform.position.x + (chunk.EndPoint.x) * chunk.BlockSize.x + 
                          (chunk.EndPoint.x - chunk.StartPoint.x) * chunk.BlockSize.x;
        return _playerPosition.position.x > deletepos;
    }

    private void DeleteFirstChunk()
    {
        if (_spawnedChunks.Count == 0) return;
        Destroy(_spawnedChunks.Dequeue().gameObject,0);
    }

    //todo: Add weighted random spawning.
    private void SpawnChunk()
    {
        var spawnLocation = _lastChunk == null ? new Vector3(InitialSpawnX, 0) : GetSpawnLocation(_lastChunk);

        int chink;
        do
        {
            chink = Random.Range(0, _possibleChunks.Length);
        }
        while (_lastChunkIndex == chink);
        _lastChunkIndex = chink;
        var o = _possibleChunks[chink] as GameObject;
        if (o != null) InstantiateChunk(o); 
    }

    private void InstantiateChunk(GameObject chunkobj)
    {
        var spawnLocation = _lastChunk == null ? new Vector3(InitialSpawnX, 0) : GetSpawnLocation(_lastChunk);
        var chunk = chunkobj.GetComponent<Chunk>();
        
        Vector3 origin = (Vector2)chunk.StartPoint;
        origin.x = (origin.x + 1) * chunk.BlockSize.x;
        origin.y *= -chunk.BlockSize.y;

        chunk = Instantiate(chunk, spawnLocation + origin, Quaternion.identity).GetComponent<Chunk>();

        _spawnedChunks.Enqueue(chunk);
        _lastChunk = chunk;
    }

    private static Vector3 GetSpawnLocation(Chunk chunk)
    {
        var location = chunk.transform.position;
        location.x += chunk.BlockSize.x * chunk.EndPoint.x;
        location.y += chunk.BlockSize.y * chunk.EndPoint.y;

        return location;
    }

}