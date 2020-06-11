using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using CielaSpike;

public class World : MonoBehaviour {
    
    public Octree<Chunk> chunks;

    public int worldSize;
    public int minSize = 256;

    public Vector3 chunkGenerationPos;

    private Queue<Vector3> ChunksToGenerate = new Queue<Vector3>();

    WorldGeneration generator;
    public bool generate = true;

    public GameObject chunkPrefab;
    public bool march = false;

    void Awake()
    {
        chunks = new Octree<Chunk>(worldSize, Vector3.zero, minSize);
        ChunksToGenerate = new Queue<Vector3>();
    }

    void Start()
    {
        for (int x = 0; x < 1; x++)
        {
            for (int y = 0; y < 1; y++)
            {
                for (int z = 0; z < 1; z++)
                {
                    AddChunk(x, y, z);
                }
            }
        }
    }

    void FixedUpdate()
    {
        /*if(march)
        {
            renderer = new OctreeMarchRenderer();
        }
        else
        {
            renderer = new OctreeBlockRenderer();
        }*/

        if (generate)
            AddChunk(chunkGenerationPos);

        StartCoroutine(CreateChunk());
    }

    public Voxel GetVoxel(int x, int y, int z)
    {
        Chunk tempChunk = GetChunk(x, y, z);
        if (tempChunk != null)
            return tempChunk.GetVoxel(x, y, z);
        return null;
    }

    public void SetVoxel(int x, int y, int z, Voxel voxel)
    {
        Chunk tempChunk = GetChunk(x, y, z);
        if (tempChunk != null)
            tempChunk.AddVoxel(x, y, z, voxel);
    }

    public void RemoveVoxel(int x, int y, int z)
    {
        Chunk tempChunk = GetChunk(x, y, z);
        if (tempChunk != null)
            tempChunk.RemoveVoxel(x, y, z);
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        float multiple = Chunk.ChunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * Chunk.ChunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * Chunk.ChunkSize;
        pos.z = Mathf.FloorToInt(z / multiple) * Chunk.ChunkSize;
        
        return chunks.Get(pos.x, pos.y, pos.z);
    }

    public void AddChunk(int x, int y, int z)
    {
        generate = false;
        ChunksToGenerate.Enqueue(new Vector3(x, y, z));
    }

    public void AddChunk(Vector3 pos)
    {
        generate = false;
        ChunksToGenerate.Enqueue(pos);
    }

    IEnumerator CreateChunk()
    {
        Task GenerationTask;
        Vector3[] TempPositions = new Vector3[ChunksToGenerate.Count];
        ChunksToGenerate.CopyTo(TempPositions, 0);
        ChunksToGenerate.Clear();

        foreach(Vector3 pos in TempPositions)
        {
            if (chunks.Get(pos) == null)
            {
                generator = new WorldGeneration();
                WorldPos TempPos = new WorldPos((int)pos.x * Chunk.ChunkSize, (int)pos.y * Chunk.ChunkSize, (int)pos.z * Chunk.ChunkSize);

                yield return Ninja.JumpToUnity;

                GameObject TempChunkObject = Instantiate(chunkPrefab) as GameObject;
                TempChunkObject.transform.SetParent(this.transform);
                TempChunkObject.name = TempPos.ToString();
                Chunk TempChunkScript = TempChunkObject.GetComponent<Chunk>();

                yield return Ninja.JumpBack;

                TempChunkScript.world = this;
                TempChunkScript.ChunkPosition = TempPos;
                this.StartCoroutineAsync(GenerateChunk(TempChunkScript), out GenerationTask);
                yield return StartCoroutine(GenerationTask.Wait());
                generator.FetchChunk(out TempChunkScript);
                chunks.Add(TempChunkScript, TempPos.ToVector3());
            }
        }
    }

    IEnumerator GenerateChunk(Chunk chunk)
    {
        generator.Generate(this, chunk);
        yield break;
    }

    public void DestroyChunk(int x, int y, int z)
    {
        chunks.Remove(new Vector3(x, y, z));
    }
}
