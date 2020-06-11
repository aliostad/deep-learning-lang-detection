using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {

    public Dictionary<int, Chunk> chunks = new Dictionary<int, Chunk>();
    public GameObject chunkPrefab;

    public string worldName = "world";

	public static GameManager instance;

	public GameObject fogPrefab;

	public Vector3 spawnPoint;

	IEnumerator Start () {
//		chunks = new OldChunk[WORLD_WIDTH,WORLD_HEIGHT];
//		for(int i = 0; i < WORLD_WIDTH; i++) {
//			for(int j = 0; j < WORLD_HEIGHT; j++) {
//				GameObject chunk = new GameObject("Chunk[" + i + " " + j + "]");
//				chunk.transform.parent = transform;
//				chunk.transform.position = new Vector3(i * OldChunk.CHUNK_WIDTH - (WORLD_WIDTH*OldChunk.CHUNK_WIDTH/2), 0f, j * OldChunk.CHUNK_HEIGHT - (WORLD_HEIGHT*OldChunk.CHUNK_HEIGHT/2));
//				chunk.AddComponent<OldChunk>();
//				chunk.GetComponent<OldChunk>().fogPrefab = fogPrefab;
//			}
//		}
		yield return new WaitForSeconds(2f);
		RaycastHit hit;
		Debug.DrawRay(new Vector3(1f, 300f, 0f), Vector3.down, Color.red, 5f);
		if(Physics.Raycast(new Vector3(1f, 3000f, 1f), Vector3.down, out hit, 3000f, LayerMask.GetMask("Blocks"))) {
			spawnPoint = new Vector3Int((int)hit.point.x, (int)hit.point.y, (int)hit.point.z);
		} else {
			Debug.LogError("Can't find spawnpoint");
		}
//		Serialization.LoadPlayer(FindObjectOfType<PlayerData>());
	}

    public void CreateChunk(int x, int y, int z)
    {
        WorldPos worldPos = new WorldPos(x, y, z);

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(
                        chunkPrefab, new Vector3(x, y, z),
                        Quaternion.Euler(Vector3.zero)
                    ) as GameObject;

        Chunk newChunk = newChunkObject.GetComponent<Chunk>();
		newChunkObject.layer = LayerMask.NameToLayer("Blocks");
        newChunk.pos = worldPos;
        newChunk.world = this;

        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos.GetHashCode(), newChunk);

        var terrainGen = new TerrainGenerator();
        newChunk = terrainGen.ChunkGen(newChunk);

        newChunk.SetBlocksUnmodified();

        Serialization.LoadChunk(newChunk);
    }

    void OnApplicationQuit() {
        SaveWorld();
    }

    public void SaveWorld() {
//		Serialization.SavePlayer(FindObjectOfType<PlayerData>());
        foreach (Chunk chunk in chunks.Values)
        {
            Serialization.SaveChunk(chunk);
        }
    }

    public void DestroyChunk(WorldPos pos)
    {
        Chunk chunk = null;
        int hash = pos.GetHashCode();
        if (chunks.TryGetValue(hash, out chunk))
        {
            Serialization.SaveChunk(chunk);
            Object.Destroy(chunk.gameObject);
            chunks.Remove(hash);
        }
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        int hash = WorldPos.GenerateHashCode(
            Mathf.FloorToInt(x / (float)Chunk.CHUNK_SIZE) * Chunk.CHUNK_SIZE,
            Mathf.FloorToInt(y / (float)Chunk.CHUNK_SIZE) * Chunk.CHUNK_SIZE,
            Mathf.FloorToInt(z / (float)Chunk.CHUNK_SIZE) * Chunk.CHUNK_SIZE
               );

        Chunk containerChunk = null;

        chunks.TryGetValue(hash, out containerChunk);

        return containerChunk;
    }

    public BlockInstance GetBlock(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y, z);

        if (containerChunk != null)
        {
            BlockInstance block = containerChunk.GetBlock(
                x - containerChunk.pos.x,
                y - containerChunk.pos.y,
                z - containerChunk.pos.z);

            return block;
        }
        else
        {
//            Debug.LogError("Block isn't in containerChunk", this);
            return new BlockInstance();
//            return BlockDatabase.GetBlock(0);
        }

    }

    public void SetBlock(int x, int y, int z, BlockData block)
    {
        Chunk chunk = GetChunk(x, y, z);

        if (chunk != null)
        {
            chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
            chunk.update = true;

            UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
            UpdateIfEqual(x - chunk.pos.x, Chunk.CHUNK_SIZE - 1, new WorldPos(x + 1, y, z));
            UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
            UpdateIfEqual(y - chunk.pos.y, Chunk.CHUNK_SIZE - 1, new WorldPos(x, y + 1, z));
            UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
            UpdateIfEqual(z - chunk.pos.z, Chunk.CHUNK_SIZE - 1, new WorldPos(x, y, z + 1));
        
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
}
