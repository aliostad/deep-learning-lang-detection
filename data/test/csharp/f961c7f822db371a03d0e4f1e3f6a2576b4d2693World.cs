using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour
{
	public static World currentWorld;
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk> ();
	public GameObject chunkPrefab;
	public string worldName = "world";
	public int seed = 0;
	public bool genChunk;

	void Awake()
	{
		currentWorld = null;
		seed = worldName.GetHashCode ();
		currentWorld = this;
	}

	// Use this for initialization
	void Start ()
	{

	}
	
	// Update is called once per frame
	void Update ()
	{

	}

	public void CreateChunk (int x, int y, int z)
	{
		WorldPos worldPos = new WorldPos (x, 0, z);

		GameObject newChunkObject = Instantiate (chunkPrefab, new Vector3 (x, 0, z), Quaternion.identity) as GameObject;
		
		Chunk newChunk = newChunkObject.GetComponent<Chunk> ();
		newChunk.name = "Chunk@" + new Vector3(x, y, z);
		newChunk.pos = worldPos;
		newChunk.world = this;
		
		//Add it to the chunks dictionary with the position as the key
		chunks.Add (worldPos, newChunk);
		
		var terrainGen = new TerrainGen ();
		newChunk = terrainGen.ChunkGen (newChunk);
		
		newChunk.SetBlocksUnmodified ();
		
		Serialization.Load (newChunk);
	}
	
	public void DestroyChunk (int x, int y, int z)
	{
		Chunk chunk = null;
		if (chunks.TryGetValue (new WorldPos (x, y, z), out chunk))
		{
			//Serialization.SaveChunk (chunk);
			Object.Destroy (chunk.gameObject);
			chunks.Remove (new WorldPos (x, y, z));
		}
	}
	
	public Chunk GetChunk (int x, int y, int z)
	{
		WorldPos pos = new WorldPos ();
		float multiple = Chunk.chunkWidth;
		pos.x = Mathf.FloorToInt (x / multiple) * Chunk.chunkWidth;
		pos.y = 0;
		pos.z = Mathf.FloorToInt (z / multiple) * Chunk.chunkWidth;
		
		Chunk containerChunk = null;
		
		chunks.TryGetValue (pos, out containerChunk);
		
		return containerChunk;
	}
	
	public Block GetBlock (int x, int y, int z)
	{
		Chunk containerChunk = GetChunk (x, y, z);
		
		if (containerChunk != null)
		{
			Block block = containerChunk.GetBlock (x - containerChunk.pos.x, y, z - containerChunk.pos.z);
			return block;
		} else
		{
			return new Block ();
		}
	}

	public Block GetBlock (WorldPos pos)
	{
		return GetBlock (pos.z, pos.y, pos.z);
	}
	
	public void SetBlock (int x, int y, int z, Block block)
	{
		Chunk chunk = GetChunk (x, y, z);
		
		if (chunk != null)
		{
			chunk.SetBlock (x - chunk.pos.x, y, z - chunk.pos.z, block);
			chunk.update = true;
			
			UpdateIfEqual (x - chunk.pos.x, 0, new WorldPos (x - 1, y, z));
			UpdateIfEqual (x - chunk.pos.x, Chunk.chunkWidth - 1, new WorldPos (x + 1, y, z));
			UpdateIfEqual (y, 0, new WorldPos (x, y - 1, z));
			UpdateIfEqual (y, Chunk.chunkHeight - 1, new WorldPos (x, y + 1, z));
			UpdateIfEqual (z - chunk.pos.z, 0, new WorldPos (x, y, z - 1));
			UpdateIfEqual (z - chunk.pos.z, Chunk.chunkWidth - 1, new WorldPos (x, y, z + 1));
		}
	}
	
	void UpdateIfEqual (int value1, int value2, WorldPos pos)
	{
		if (value1 == value2)
		{
			Chunk chunk = GetChunk (pos.x, pos.y, pos.z);
			if (chunk != null)
				chunk.update = true;
		}
	}
}
