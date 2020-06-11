using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class WorldGenerator : SingletonBehaviour<WorldGenerator> {

    public float Step = 100;

    private float AllowedPosition {
        get {
            return _LastChunkPosition;
        }
    }

    private static Transform ChunksPoolHost {
        get {
            return _ChunksPoolHost;
        }
    }
    private static Transform _ChunksPoolHost;

    private int _LastChunkID;
    private float _LastChunkPosition;
    private Queue<WorldChunk> _CurrentChunks = new Queue<WorldChunk>();
    private static List<WorldChunk> _Chunks = new List<WorldChunk>();

    protected override void Awake() {
        base.Awake();
        InitializeChunkPool();
        _LastChunkPosition = -Step;
        Update();
    }

    protected override void OnDestroy() {
        base.OnDestroy();
        foreach(var chunk in _CurrentChunks) {
            ReleaseChunk(chunk);
        }
    }

    void Update() {
        if (PlayerController.LocalPlayer.transform.position.z > AllowedPosition)
            PrepareNextChunk();
    }

    private void InitializeChunkPool() {
        if (_ChunksPoolHost == null) {
            _ChunksPoolHost = new GameObject("ChunksPool").transform;
            DontDestroyOnLoad(_ChunksPoolHost);
            Instance.PreloadChunks();
        }
    }

    private void PreloadChunks() {
        foreach (var chunkData in ChunkConfig.Instance.Chunks) {
            CreateChunk(chunkData.ID);
            CreateChunk(chunkData.ID);
        } 
    }

    private void PrepareNextChunk() {
        var chunkID = EvaluateNextChunkID();
        var chunk = GetChunk(chunkID);
        chunk.transform.SetParent(this.transform);
        chunk.transform.position = new Vector3(0, 0, _LastChunkPosition + Step);
        chunk.gameObject.SetActive(true);
        _CurrentChunks.Enqueue(chunk);
        if(_CurrentChunks.Count > 3) {
           ReleaseChunk(_CurrentChunks.Dequeue());
        }

        _LastChunkPosition += Step;
        _LastChunkID = chunkID;
    }

    private void ReleaseChunk(WorldChunk chunk) {
        chunk.gameObject.SetActive(false);
        if (ChunksPoolHost) {
            chunk.transform.SetParent(ChunksPoolHost);
        }
    }

    private int EvaluateNextChunkID() {
        var selection = ChunkConfig.Instance.Chunks.Where(_ => _.ID != _LastChunkID);
        return selection.ElementAt(Random.Range(0, selection.Count())).ID;
    }

    private WorldChunk GetChunk(int id) {
        var chunk = _Chunks.FirstOrDefault(_ => _.Data.ID == id && !_.gameObject.activeSelf);
        if (chunk == null) {
            chunk = CreateChunk(id);
        }
        return chunk;
    }

    private WorldChunk CreateChunk(int id) {
        var chunk = Instantiate(ChunkConfig.Instance.GetChunkData(id).Prefab, ChunksPoolHost);
        chunk.gameObject.SetActive(false);
        _Chunks.Add(chunk);
        return chunk;
    }
}
