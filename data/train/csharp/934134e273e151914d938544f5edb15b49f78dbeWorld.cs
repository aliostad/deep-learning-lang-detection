using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//create chunks, and serves as a terminal for them to communicate their position, and instantiation.
public class World : MonoBehaviour 
{
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
	public GameObject chunkPrefab;

	void Start()
	{
		
		for (int x = -2; x < 2; x++)
		{
			for (int y = -1; y < 1; y++)
			{
				for (int z = -1; z < 1; z++)
				{
					CreateChunk(x * 16, y* 16, z * 16);
				}
			}
		}
	}
	public void CreateChunk(int x, int y, int z)
	{
		WorldPos worldPos = new WorldPos(x, y , z);
		
		//Instantiate the chunk at the coordinates using the chunk prefab
		GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(x, y, z),Quaternion.Euler(Vector3.zero)) as GameObject;
		
		Chunk newChunk = newChunkObject.GetComponent<Chunk>();
		
		newChunk.pos = worldPos;
		newChunk.world = this;
		
		//Adds to dictionary
		chunks.Add(worldPos, newChunk);
	}
	public Chunk GetChunk(int x, int y, int z)
	{
		WorldPos pos = new WorldPos();
		float multiple = Chunk.chunkSize;
		pos.x = Mathf.FloorToInt(x / multiple ) * Chunk.chunkSize;
		pos.y = Mathf.FloorToInt(y / multiple ) * Chunk.chunkSize;
		pos.z = Mathf.FloorToInt(z / multiple ) * Chunk.chunkSize;
		
		Chunk containerChunk = null;
		
		chunks.TryGetValue(pos, out containerChunk);
		for (int xi = 0; xi < 16; xi++)
		{
			for (int yi = 0; yi < 16; yi++)
			{
				for (int zi = 0; zi < 16; zi++)
				{
					if (yi <= 7)
					{
						SetBlock(x+xi, y+yi, z+zi, new BlockGrass());
					}
					else
					{
						SetBlock(x + xi, y + yi, z + zi, new BlockAir());
					}
				}
			}
		}
		return containerChunk;
	}
	
	public BlockScript GetBlock(int x, int y, int z)
	{
		Chunk containerChunk = GetChunk(x, y, z);
		
		if (containerChunk != null)
		{
			BlockScript block = containerChunk.GetBlock(
				x - containerChunk.pos.x,
				y -containerChunk.pos.y, 
				z - containerChunk.pos.z);
			
			return block;
		}
		else
		{
			return new BlockAir();
		}
		
	}

	public void SetBlock(int x, int y, int z, BlockScript block)
	{
		Chunk chunk = GetChunk(x, y, z);
		
		if (chunk != null)
		{
			chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
			chunk.update = true;
		}
	}


	public void DestroyChunk(int x, int y, int z)
	{
		Chunk chunk = null;
		if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
		{
			Object.Destroy(chunk.gameObject);
			chunks.Remove(new WorldPos(x, y, z));
		}
	}
}