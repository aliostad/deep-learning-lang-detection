using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class World : MonoBehaviour
{
    public Dictionary<Vector3, Chunk> chunks = new Dictionary<Vector3, Chunk>();

    public struct ChunkData
    {
        public Vector3 WorldPosition;
        public Chunk Chunk;
        public World World;

        public ChunkData(Vector3 wPos, Chunk c, World w)
        {
            WorldPosition = wPos;
            Chunk = c;
            World = w;
        }
    }

    private static Vector3[] defaultChunkPositions =
    {
        new Vector3( 0, 0,  0), new Vector3(-1, 0,  0), new Vector3( 0, 0, -1), new Vector3( 0, 0,  1), new Vector3( 1, 0,  0),
        new Vector3(-1, 0, -1), new Vector3(-1, 0,  1), new Vector3( 1, 0, -1), new Vector3( 1, 0,  1), new Vector3(-2, 0,  0),
        new Vector3( 0, 0, -2), new Vector3( 0, 0,  2), new Vector3( 2, 0,  0), new Vector3(-2, 0, -1), new Vector3(-2, 0,  1),
        new Vector3(-1, 0, -2), new Vector3(-1, 0,  2), new Vector3( 1, 0, -2), new Vector3( 1, 0,  2), new Vector3( 2, 0, -1),
        new Vector3( 2, 0,  1)
    };

    [SerializeField] private Transform chunkContainer;
    [SerializeField] private GameObject chunkPrefab;

    private Chunk[] chunkPool;
    private List<ChunkData> chunkQueue;
    private bool isBuilding = false;

    public string worldName = "World";
    private TerrainGenerator terrainGen = new TerrainGenerator();
    private Vector3 previousPlayerPos = new Vector3();
    private Vector3 currentPlayerPos = new Vector3();
    private float chunkRange = 40;
    private int queueBuildSize = 10;

    private BuildJob _buildJob;
    
    private void Start()
    {
        VSEventManager.Instance.AddListener<GameEvents.PlayerPositionUpdateEvent>(OnPlayerPositionUpdated);

        int numChunks = 300;
        Init(numChunks);
    }

    private void OnDestroy()
    {
        VSEventManager.Instance.RemoveListener<GameEvents.PlayerPositionUpdateEvent>(OnPlayerPositionUpdated);
    }

    public void Init(int numChunks)
    {
        chunkPool = new Chunk[numChunks];
        for (int i = 0; i < numChunks; i++)
        {
            SpawnChunkObj(i);
        }

        chunkQueue = new List<ChunkData>();

        _buildJob = new BuildJob();
        _buildJob.Setup();
    }

    private void OnPlayerPositionUpdated(GameEvents.PlayerPositionUpdateEvent e)
    {
        previousPlayerPos = currentPlayerPos;

        // check for new position
        currentPlayerPos.x = SimplexNoise.Noise.FastFloor(e.PlayerPosition.x / Chunk.chunkSize) * Chunk.chunkSize;
        currentPlayerPos.y = SimplexNoise.Noise.FastFloor(e.PlayerPosition.y / Chunk.chunkSize) * Chunk.chunkSize;
        currentPlayerPos.z = SimplexNoise.Noise.FastFloor(e.PlayerPosition.z / Chunk.chunkSize) * Chunk.chunkSize;

        if (currentPlayerPos.x != previousPlayerPos.x ||
            currentPlayerPos.z != previousPlayerPos.z)
        {
            ProcessChunks(currentPlayerPos);
            //StartCoroutine(RemoveChunks());
        }
    }

    private void ProcessChunks(Vector3 playerPos)
    {
        //Cycle through the array of positions
        for (int i = 0; i < defaultChunkPositions.Length; i++)
        {
            //translate the player position and array position into chunk position
            Vector3 newChunkPos = new Vector3(defaultChunkPositions[i].x * Chunk.chunkSize + playerPos.x, 0, defaultChunkPositions[i].z * Chunk.chunkSize + playerPos.z);

            //Get the chunk in the defined position
            int newChunkX = (int)newChunkPos.x;
            int newChunkY = (int)newChunkPos.y;
            int newChunkZ = (int)newChunkPos.z;

            Chunk newChunk = GetChunk(newChunkX, newChunkY, newChunkZ);

            //If the chunk already exists and it's already built, skip it
            if (newChunk != null && (newChunk.rendered || IsChunkOutOfRange(newChunkPos)))
            {
                continue;
            }

            // load chunk
            //StartCoroutine(BuildChunkColumn(newChunkX, newChunkZ));
            BuildChunkColumn(newChunkX, newChunkZ);

            return;
        }
    }

    // loads a column of chunks at a given x and z
    //private IEnumerator BuildChunkColumn(int chunkX, int chunkZ)
    private void BuildChunkColumn(int chunkX, int chunkZ)
    {
        int topMost = 4;
        int bottomMost = -2;
        for (int y = topMost; y > bottomMost; y--)
        {
            for (int x = chunkX - Chunk.chunkSize; x <= chunkX + Chunk.chunkSize; x += Chunk.chunkSize)
            {
                for (int z = chunkZ - Chunk.chunkSize; z <= chunkZ + Chunk.chunkSize; z += Chunk.chunkSize)
                {
                    // create it if one doesn't exist
                    if (GetChunk(x, y * Chunk.chunkSize, z) == null)
                    {
                        QueueChunk(x, y * Chunk.chunkSize, z);

                        //yield return new WaitForEndOfFrame();
                        //yield return null;
                    }
                }
            }
        }
    }

    private IEnumerator RemoveChunks()
    {
        List<Vector3> keys = new List<Vector3>(chunks.Keys);
        for (int i = 0; i < keys.Count; i++)
        {
            if (IsChunkOutOfRange(keys[i]))
            {
                DestroyChunk((int)keys[i].x, (int)keys[i].y, (int)keys[i].z);

                yield return new WaitForEndOfFrame();
            }
        }
    }

    private bool IsChunkOutOfRange(Vector3 chunkVector3)
    {
        float sqrDist = (chunkVector3 - currentPlayerPos).sqrMagnitude;
        return (sqrDist > (chunkRange * chunkRange));
    }

    private void SpawnChunkObj(int poolIndex)
    {
        GameObject newChunkObject = (GameObject)Instantiate(chunkPrefab, chunkContainer);

        Chunk newChunk = newChunkObject.GetComponent<Chunk>();
        newChunk.inPool = true;
        chunkPool[poolIndex] = newChunk;
    }

    private void OnBuildJobFinished(List<Chunk> data)
    {
        StartCoroutine(DrawChunks(data));
    }

    private IEnumerator DrawChunks(List<Chunk> data)
    {
        for (int i = 0; i < data.Count; i++)
        {
            data[i].DrawChunk();
            //data[i].inPool = false;

            yield return null;
        }
    }

    private Chunk GetUnusedChunkFromPool()
    {
        Chunk c = null;
        for (int i = 0; i < chunkPool.Length; i++)
        {
            if (chunkPool[i].inPool)
            {
                c = chunkPool[i];
                break;
            }
        }

        if (c == null) Debug.LogError("Chunk Pool was is empty");

        return c;
    }

    public void QueueChunk(int x, int y, int z)
    {
        Vector3 worldPos = new Vector3(x, y, z);
        Chunk newChunk = GetUnusedChunkFromPool();
        if (newChunk != null)
        {
            newChunk.inPool = false;

            // set this stuff here, because it's Unity API which can't be done in the thread or we don't have access to it
            newChunk.transform.position = worldPos;
            newChunk.gameObject.name = string.Format("Chunk [{0},{1},{2}]", x, y, z);

            if (!chunks.ContainsKey(worldPos))
            {
                chunks.Add(worldPos, newChunk);
            }
            else
            {
                Debug.LogError("Duplicate Entry in Chunks Dictionary > " + newChunk.gameObject.name);
            }

            // add the new chunkData to the queue
            ChunkData cData = new ChunkData(worldPos, newChunk, this);
            chunkQueue.Add(cData);
        }
    }

    private void Update()
    {
        if (isBuilding)
        {
            if (_buildJob.Update())
            {
                // chunk work is done, fraw resulting chunks
                OnBuildJobFinished(_buildJob.GetFinishedData());
                isBuilding = false;
            }
        }
        else
        {
            if (chunkQueue.Count >= queueBuildSize)
            {
                _buildJob.SetQueue(chunkQueue);
                chunkQueue.Clear();

                _buildJob.Start();
                isBuilding = true;
            }
        }
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        Vector3 pos = new Vector3();
        pos.x = Mathf.FloorToInt(x / (float)Chunk.chunkSize) * Chunk.chunkSize;
        pos.y = Mathf.FloorToInt(y / (float)Chunk.chunkSize) * Chunk.chunkSize;
        pos.z = Mathf.FloorToInt(z / (float)Chunk.chunkSize) * Chunk.chunkSize;
        Chunk containerChunk = null;
        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new Vector3(x, y, z), out chunk))
        {
            //Serialization.SaveChunk(chunk);
            //Destroy(chunk.gameObject);
            chunk.ClearChunk();
            chunks.Remove(new Vector3(x, y, z));
            chunk.inPool = true;
        }
    }

    public void SetBlock(int x, int y, int z, Block block)
    {
        Chunk chunk = GetChunk(x, y, z);

        if (chunk != null)
        {
            chunk.SetBlock(x - (int)chunk.worldPos.x, y - (int)chunk.worldPos.y, z - (int)chunk.worldPos.z, block);
            chunk.DrawChunk();

            // update adjacent chunks
            UpdateIfEqual(x - (int)chunk.worldPos.x, 0, new Vector3(x - 1, y, z));
            UpdateIfEqual(x - (int)chunk.worldPos.x, Chunk.chunkSize - 1, new Vector3(x + 1, y, z));
            UpdateIfEqual(y - (int)chunk.worldPos.y, 0, new Vector3(x, y - 1, z));
            UpdateIfEqual(y - (int)chunk.worldPos.y, Chunk.chunkSize - 1, new Vector3(x, y + 1, z));
            UpdateIfEqual(z - (int)chunk.worldPos.z, 0, new Vector3(x, y, z - 1));
            UpdateIfEqual(z - (int)chunk.worldPos.z, Chunk.chunkSize - 1, new Vector3(x, y, z + 1));

        }
    }

    public Block GetBlock(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y, z);
        if (containerChunk != null)
        {
            Block block = containerChunk.GetBlock(
                x - (int)containerChunk.worldPos.x,
                y - (int)containerChunk.worldPos.y,
                z - (int)containerChunk.worldPos.z);

            return block;
        }
        else
        {
            return new BlockAir();
        }
    }

    void UpdateIfEqual(int value1, int value2, Vector3 pos)
    {
        if (value1 == value2)
        {
            Chunk chunk = GetChunk((int)pos.x, (int)pos.y, (int)pos.z);
            if (chunk != null)
                chunk.DrawChunk();
        }
    }
}
