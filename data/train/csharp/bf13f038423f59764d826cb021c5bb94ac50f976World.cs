using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Threading;

[Serializable]
public class World : MonoBehaviour {

	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
	public GameObject chunkPrefab;
	public string worldName = "world";
	/*
	public int newChunkX;
	public int newChunkY;
	public int newChunkZ;

	public bool genChunk;
*/
	public void createChunk (int x, int y, int z)
	{
		WorldPos worldPos = new WorldPos (x, y, z);

		//Instantiate a new Chunk at the coordinates
		GameObject newChunkObject = Instantiate (chunkPrefab, new Vector3 (x, y, z), 
		                                         Quaternion.Euler (Vector3.zero)) as GameObject;

		Chunk newChunk = newChunkObject.GetComponent<Chunk> ();

		newChunk.pos = worldPos;
		newChunk.world = this;

		//Add the new Chunk to the dictionary at this world position
		chunks.Add (worldPos, newChunk);

		TerrainGen terrainGen = new TerrainGen ();
		newChunk = terrainGen.ChunkGen (newChunk);

		newChunk.setBlocksUnmodified ();
		Serialization.loadChunk (newChunk);
	}

	public void destroyChunk (int x, int y, int z)
	{
		Chunk chunk = null;

		if (chunks.TryGetValue (new WorldPos (x, y, z), out chunk))
		{
			Serialization.saveChunk(chunk);
			UnityEngine.Object.Destroy (chunk.gameObject);
			chunks.Remove (new WorldPos (x, y, z));
		}
	}

	//Gets chunk at specified world position
	public Chunk getChunk (int x, int y, int z)
	{
		WorldPos pos = new WorldPos ();
		float multiple = Chunk.chunkSize;

		//Find the start of the nearest chunk - each Chunk is a multiple of 16 so first starts at 0 then 16 then 32 etc 
		//ie. a world position of x = 45 -- 45 / 16 = 2.8 -- floor(2.8) = 2 -- 2 * 16 = 32;
		pos.x = Mathf.FloorToInt (x / multiple) * Chunk.chunkSize;
		pos.y = Mathf.FloorToInt	 (y / multiple) * Chunk.chunkSize;
		pos.z = Mathf.FloorToInt (z / multiple) * Chunk.chunkSize;

		Chunk containerChunk = null;

		//Tries to retrieve the chunk from the chunk dictionary
		chunks.TryGetValue (pos, out containerChunk);

		return containerChunk;
	}

	//Gets block from chunk at specified world position
	public Block getBlock (int x, int y, int z)
	{
		Chunk containerChunk = getChunk (x, y, z);

		if (containerChunk != null)
		{
			//block at world position x = 47 from chunk at x = 45
			//already seen above that chunk pos = 32
			//therefore, 47 - 32 = 15, therefore, block [15, y, z] is the one we need
			Block block = containerChunk.getBlock (x - containerChunk.pos.x,
			                                       y - containerChunk.pos.y,
			                                       z - containerChunk.pos.z);

			return block;
		}
		else
		{
			return new BlockAir();
		}
	}

	public void setBlock (int x, int y, int z, Block block)
	{
		Chunk chunk = getChunk (x, y, z);

		if (chunk != null)
		{
			chunk.setBlock (x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
			chunk.update = true;

			updateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
			updateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
			updateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
			updateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
			updateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
			updateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
		}
	}

	void updateIfEqual (int value1, int value2, WorldPos pos)
	{
		if (value1 == value2)
		{
			Chunk chunk = getChunk (pos.x, pos.y, pos.z);
			if (chunk != null)
			{
				chunk.update = true;
			}
		}
	}

	void Start () {

		if (Application.loadedLevelName.Equals("Menu")) {
			for (int x = -4; x < 4; x++)
			{
				for (int y = -1; y < 3; y++)
				{
					for (int z = -4; z < 4; z++)
					{
						createChunk(x * 16, y * 16, z * 16);
					}
				}
			}
		}
	}

	/*
	// Use this for initialization
	void Start () {
	
		for (int x = -4; x < 4; x++)
		{
			for (int y = -1; y < 3; y++)
			{
				for (int z = -4; z < 4; z++)
				{
					createChunk(x * 16, y * 16, z * 16);
				}
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		if (genChunk)
		{
			genChunk = false;
			WorldPos chunkPos = new WorldPos (newChunkX, newChunkY, newChunkZ);
			Chunk chunk = null;

			if (chunks.TryGetValue(chunkPos, out chunk))
			{
				destroyChunk(chunkPos.x, chunkPos.y, chunkPos.z);
			}
			else
			{
				createChunk(chunkPos.x, chunkPos.y, chunkPos.z);
			}
		}
	}*/
}