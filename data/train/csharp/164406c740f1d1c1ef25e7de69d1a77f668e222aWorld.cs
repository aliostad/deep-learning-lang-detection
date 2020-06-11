using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace OldCode {
public class World : MonoBehaviour {
    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
    public GameObject chunkPrefab;
	public bool IsLoadChunks = true;
    public string worldName = "world";
	public string SaveFileName = "";
	public int LightValueMin = 30;
	public LoadChunks ChunkLoader;
	public TerrainGen MyTerrainGen = new TerrainGen();
	public int DebugChunksLoadedCount = 0;
	public int DebugPolygonCount = 0;
	public bool IsLighting = true;

	void Start() {
		MyTerrainGen.Start ();
	}
    public void CreateChunk(int x, int y, int z) {
        WorldPos worldPos = new WorldPos(x, y, z);

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(
                        chunkPrefab, new Vector3(x, y, z),
                        Quaternion.Euler(Vector3.zero)
                    ) as GameObject;
        Chunk newChunk = newChunkObject.GetComponent<Chunk>();
		newChunkObject.name = "Chunk: " + x/16f + ":" + y/16f + ":" + z/16f;
        newChunk.pos = worldPos;
        newChunk.world = this;

        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);

		bool HasLoadedChunk = false;


		if ((Network.isServer || (!Network.isServer && !Network.isClient)) && IsLoadChunks) 
			HasLoadedChunk = Serialization.Load(newChunk);
		if (!HasLoadedChunk) {
			newChunk = MyTerrainGen.ChunkGen(newChunk);
		}
		newChunk.transform.parent = gameObject.transform;
		newChunk.SetBlocksUnmodified();
		GetManager.GetZoneManager ().LoadZones (new Vector3 (x, y, z));
		DebugChunksLoadedCount++;
    }

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {	
			// atm it is saved when it is removed
			if (SaveFileName == "") {	// if default then update to the game file name
				SaveFileName = GetManager.GetGameManager().GameName;
			}
			DebugPolygonCount -= chunk.PolygonCount;
            Serialization.SaveChunk(chunk);
            Object.Destroy(chunk.gameObject);
			chunks.Remove(new WorldPos(x, y, z));
        }
		GetManager.GetZoneManager ().DestroyZonesInCubeNotCentred (new Vector3 (x, y, z), 
		                                                 new Vector3 (Chunk.chunkSize, Chunk.chunkSize, Chunk.chunkSize));
		DebugChunksLoadedCount--;
    }
	
	public Chunk GetChunk(float x, float y, float z)
	{
		return GetChunk (Mathf.FloorToInt (x), Mathf.FloorToInt (y), Mathf.FloorToInt (z));
	}
    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        float multiple = Chunk.chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize;
        pos.z = Mathf.FloorToInt(z / multiple) * Chunk.chunkSize;

        Chunk containerChunk = null;

        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }
	
	public Block GetBlock2(int x, int y, int z)
	{
		Chunk containerChunk = GetChunk(x, y, z);
		
		if (containerChunk != null)
		{
			Block block = containerChunk.GetBlock2(
				x - containerChunk.pos.x,
				y - containerChunk.pos.y,
				z - containerChunk.pos.z);
			
			return block;
		}
		else
		{
			return null;
			//return new Block();
		}
	}
	public BlockBase GetBlock(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y, z);

        if (containerChunk != null)
        {
			BlockBase block = containerChunk.GetBlock(
                x - containerChunk.pos.x,
                y - containerChunk.pos.y,
                z - containerChunk.pos.z);

            return block;
        }
        else
        {
            return new BlockAir();
        }
	}

	// this should check the block data if it can be removed
	[RPC]
	public void SetBlockAir(int x, int y, int z) {
		Chunk chunk = GetChunk(x, y, z);
		
		if (chunk != null)
		{
			chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new BlockAir());
			chunk.AddToUpdateList();
			
			UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
			UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
			UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
			UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
			UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
			UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
			
		}
	}
	[RPC]
	public void SetBlock(int x, int y, int z, int BlockType) {
		Chunk chunk = GetChunk(x, y, z);
		
		if (chunk != null)
		{
			chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, new Block(BlockType));
			chunk.AddToUpdateList();
			
			UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
			UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
			UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
			UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
			UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
			UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
			
		}
	}
	public void SetBlock(int x, int y, int z, BlockBase block)
    {
        Chunk chunk = GetChunk(x, y, z);

        if (chunk != null)
        {
			chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
			chunk.AddToUpdateList();

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
				chunk.AddToUpdateList();
        }
    }
}
}
