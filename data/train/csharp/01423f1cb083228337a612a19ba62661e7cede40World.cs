using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Linq;

/// <summary>
/// Base world class. Multiple worlds are allowed.
/// </summary>
public class World : MonoBehaviour {

    /// <summary>
    /// Static values across the worlds.
    /// </summary>
    public static int CHUNK_SIZE = 16; //Chunk size in all worlds, can not be changed per world ( by default )
    public static int X_RENDER_CHUNKS = 3; //Number of chunks to render on x axis
    public static int Y_RENDER_CHUNKS = 2; //Number of chunks to render on y axis
    public static int WORLD_HEIGHT_CHUNKS = 16; // The number of chunks that define the world height.
    public enum WorldSizes {
        Small = 32,
        Medium = 64,
        Large = 128
    }

    /// <summary>
    /// Used for loading and saving the world.
    /// </summary>
    public string worldName = "BaseWorld";

    /// <summary>
    /// Used for data generation of the world.
    /// </summary>
    public WorldSizes worldSize = WorldSizes.Small;

    /// <summary>
    /// Used for defining the world surface height.
    /// </summary>
    [Range(0, 128)]
    public int height = 64;

    /// <summary>
    /// Used as seed to noise generators.
    /// </summary>
    public int seed = 0;

    /// <summary>
    /// Render target.
    /// </summary>
    public Transform target;

    /// <summary>
    /// Center the target in the world.
    /// </summary>
    public bool CenterTargetInWorld = false;

    /// <summary>
    /// All chunks loaded in the world.
    /// </summary>
    private Dictionary<Vector2, Chunk> loadedChunks;

    /// <summary>
    /// Old target chunk position at which world got rendered.
    /// </summary>
    private Vector2 oldChunkPosition;

    /// <summary>
    /// World Data.
    /// </summary>
    protected ushort[,] worldData;

    /// <summary>
    /// Helper variables to calculate tiles totals and iterators. 
    /// </summary>
    protected int worldWidth;
    protected int worldHeight;

    /// <summary>
    /// Reference to the class per world.
    /// </summary>
    internal ChunkMeshCreatorPool MeshCreatorPool;

    /// <summary>
    /// Helper variables to calculate tiles totals and iterators. 
    /// </summary>
//    [HideInInspector]
    public EntityID entityID;

    // Use this for initialization. Executed before Start method.
    public void Awake() {
        loadedChunks = new Dictionary<Vector2, Chunk>();
        oldChunkPosition = new Vector2(float.MaxValue, float.MaxValue);

        worldWidth = (int)worldSize * CHUNK_SIZE;
        worldHeight = WORLD_HEIGHT_CHUNKS * CHUNK_SIZE;
        
        CenterTarget();

        //ChunksBuffer = new List<Chunk>();
        MeshCreatorPool = new ChunkMeshCreatorPool();
        //ChunksToBeGenerated = new List<Chunk>();
        //SaveManager = new ChunkSave();
        //SaveManager.Load(WorldName);

        OnAwake();
    }


    // Use this for initialization
    void Start () {
	    if (target == null) {
            Debug.LogError("Missing world target!");
            Debug.Break();
        }
	}
	

	// Update is called once per frame
	void Update () {
        Vector2 targetChunkPosition = Utilities.PositionInChunks(target.position);

        if (UpdateChunksToDisable(targetChunkPosition)) {
            UpdateChunksToEnable(targetChunkPosition);
        }
        ReBuildChunks();
    }


    /// <summary>
    /// Verify if when moving the target, distant chunks need to be disabled.
    /// </summary>
    private bool UpdateChunksToDisable(Vector2 targetChunkPosition) {
        bool positionUpdated = false;

        //Check position of the target
        if (targetChunkPosition != oldChunkPosition) {
            //Update position
            oldChunkPosition = targetChunkPosition;
            positionUpdated = true;

            foreach (Vector2 chunkCoord in loadedChunks.Keys) {
                if ((Mathf.Abs(targetChunkPosition.x - chunkCoord.x) > X_RENDER_CHUNKS) ||
                      (Mathf.Abs(targetChunkPosition.y - chunkCoord.y) > Y_RENDER_CHUNKS)) {
                    loadedChunks[chunkCoord].markedToDisable = true;
                    //Debug.Log("Chunk [X: " + chunkCoord.x + " Y: " + chunkCoord.y + "]");
                    //loadedChunks[chunkCoord].Disable();
                }
            }
            //var k = loadedChunks.Keys;
            //for (int x = 0; x < k.Count; x++) {
            //    Vector2 chunkCoord = loadedChunks.Keys.ElementAt(x);
            //    if ((Mathf.Abs(targetChunkPosition.x - chunkCoord.x) > X_RENDER_CHUNKS) ||
            //          (Mathf.Abs(targetChunkPosition.y - chunkCoord.y) > Y_RENDER_CHUNKS)) {
            //        Debug.Log("Chunk [X: " + chunkCoord.x + " Y: " + chunkCoord.y + "]");
            //        GameObject.Destroy(loadedChunks[chunkCoord].gameObject);
            //        loadedChunks.Remove(chunkCoord);
            //    }
            //}
        }
        return positionUpdated;
    }


    /// <summary>
    /// When target moves activate or create new chunks.
    /// </summary>
    private void UpdateChunksToEnable(Vector2 targetChunkPosition) {
        int minX = (int)targetChunkPosition.x - X_RENDER_CHUNKS;
        int maxX = (int)targetChunkPosition.x + X_RENDER_CHUNKS;
        int minY = (int)targetChunkPosition.y - Y_RENDER_CHUNKS;
        int maxY = (int)targetChunkPosition.y + Y_RENDER_CHUNKS;
        minX = (minX < 0) ? 0 : minX;
        maxX = (maxX > ((int)worldSize - 1)) ? ((int)worldSize - 1) : maxX;
        minY = (minY < 0) ? 0 : minY;
        maxY = (maxY > (WORLD_HEIGHT_CHUNKS - 1)) ? (WORLD_HEIGHT_CHUNKS - 1) : maxY;

        for (int chunkX = minX; chunkX <= maxX; chunkX++) {
            for (int chunkY = minY; chunkY <= maxY; chunkY++) {
                if (loadedChunks.ContainsKey(new Vector2(chunkX, chunkY))) {
                    EnableChunk(chunkX, chunkY);
                } else {
                    AddChunk(chunkX, chunkY);
                }
            }
        }
    }


    /// <summary>
    /// This cost a lot, call it when you finish editing all chunks - in order to see the result.
    /// </summary>
    public void ReBuildChunks() {
        float closest = Mathf.Infinity;
        Chunk chunk = null;

        foreach (Chunk loadedChunk in loadedChunks.Values) {
            if (loadedChunk.flaggedToUpdate && loadedChunk.hasOneBlock && !loadedChunk.generating) {
                float dist = Vector2.Distance((Vector2)loadedChunk.transform.position, target.position);
                if (dist < closest) {
                    closest = dist;
                    chunk = loadedChunk;
                }
            }
        }

        if (chunk == null)
            return;

        chunk.flaggedToUpdate = false;
        chunk.UpdateChunk();
    }


    /// <summary>
    /// Enable a chunk that already exist on the Hierarchy.
    /// </summary>
    private void EnableChunk(int chunkX, int chunkY) {
        Chunk chunk;
        //Chunks is already created at this position
        chunk = loadedChunks[new Vector2(chunkX, chunkY)];
        if (!chunk.gameObject.activeSelf)
            chunk.Enable();
        chunk.markedToDisable = false;
    }


    /// <summary>
    /// Create a new chunk and place at the Hierarchy.
    /// </summary>
    private void AddChunk(int chunkX, int chunkY) {
        Chunk chunk;

        //We need to create new chunk
        GameObject obj = new GameObject("Chunk [X: " + chunkX + " Y: " + chunkY + "]");
        obj.transform.SetParent(transform);
        obj.layer = gameObject.layer;

        chunk = obj.AddComponent<Chunk>();
        chunk.transform.position = new Vector3(chunkX * CHUNK_SIZE, chunkY * CHUNK_SIZE, transform.position.z);

        //Neighbours
        Chunk LeftChunk, RightChunk, TopChunk, BotChunk;

        //Get and set neighbours
        loadedChunks.TryGetValue(new Vector2(chunkX - 1, chunkY), out LeftChunk);
        if (LeftChunk) {
            LeftChunk.Right = chunk;
            chunk.Left = LeftChunk;
        }

        loadedChunks.TryGetValue(new Vector2(chunkX + 1, chunkY), out RightChunk);
        if (RightChunk) {
            RightChunk.Left = chunk;
            chunk.Right = RightChunk;
        }

        loadedChunks.TryGetValue(new Vector2(chunkX, chunkY + 1), out TopChunk);
        if (TopChunk) {
            TopChunk.Bot = chunk;
            chunk.Top = TopChunk;
        }

        loadedChunks.TryGetValue(new Vector2(chunkX, chunkY - 1), out BotChunk);
        if (BotChunk) {
            BotChunk.Top = chunk;
            chunk.Bot = BotChunk;
        }

        //if (loadedChunk) {
        //    chunk.Data = savedChunk.Data;
        //    chunk.HasOneBlock = savedChunk.HasOneBlock;
        //}

        //Init chunk
        chunk.Init(this);

        //Add to dictionary
        loadedChunks.Add(new Vector2(chunkX, chunkY), chunk);

        //ChunkData savedChunk = SaveManager.LoadChunk(new Vector2(x, y));
        //bool loadedChunk = savedChunk == null ? false : true;
        bool loadedChunk = false;
        if (!loadedChunk) {
            //On chunk created
            OnChunkCreated(chunkX, chunkY, chunk);
        }

        //Flag
        chunk.flaggedToUpdate = true;
    }

    private void CenterTarget() {
        if (!CenterTargetInWorld)
            return;
        int worldCenterX = worldWidth / 2;
        //int worldCenterY = worldHeight / 2;
        int worldCenterY = height;
        target.position = new Vector3(worldCenterX, worldCenterY, target.position.z);
    }

    public void RebuildAll() {
        Chunk[] c = GetComponentsInChildren<Chunk>();
        for (int i = 0; i < c.Length; i++) {
            GameObject.Destroy(c[i].gameObject);
        }
        loadedChunks.Clear();
        Awake();
    }

    /// <summary>
    /// Called when Awake has ended.
    /// </summary>
    protected virtual void OnAwake() {
        worldData = new ushort[worldWidth, worldHeight];
        Debug.LogWarning("[FallBackWorld] Creating Base Tiles with EntityID.B_AIR");
        for (int worldX = 0; worldX < worldWidth; worldX++) {
            for (int worldY = 0; worldY < worldHeight; worldY++) {
                worldData[worldX, worldY] = EntityID.B_AIR;
            }
        }
    }


    /// <summary>
    /// Called when chunk is created!
    /// </summary>
    protected virtual void OnChunkCreated(int chunkX, int chunkY, Chunk chunk) {
        for (int x = 0; x < CHUNK_SIZE; x++) {
            for (int y = 0; y < CHUNK_SIZE; y++) {
                int worldX = (chunkX * CHUNK_SIZE) + x;
                int worldY = (chunkY * CHUNK_SIZE) + y;
                chunk.SetTileLocal(x, y, worldData[worldX, worldY]);
            }
        }
    }

    public void Log(string msg) {
        Debug.Log("[" + worldName + "] " + msg);
    }


}
