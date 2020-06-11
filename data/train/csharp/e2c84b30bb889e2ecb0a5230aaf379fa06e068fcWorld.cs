using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour
{
	public string worldName = "world";
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();

	public GameObject chunkPrefab;

	public void CreateChunk(int x, int y, int z)
	{
		WorldPos worldPos = new WorldPos(x, y, z);

		//Instantiate the chunk at the coordinates using the chunk prefab
		GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(x, y, z), Quaternion.Euler(Vector3.zero)) as GameObject;

		Chunk newChunk = newChunkObject.GetComponent<Chunk>();

		newChunk.pos = worldPos;
		newChunk.world = this;

		//Add it to the chunks dictionary with the position as the key
		chunks.Add(worldPos, newChunk);

		//Generate the terrain
		TerrainGeneration terrainGen = new TerrainGeneration();
		newChunk = terrainGen.ChunkGen(newChunk);
		newChunk.SetBlocksUnmodified();
		Serialization.Load(newChunk);
	}

	public void DestroyChunk(int x, int y, int z)
	{
		Chunk chunk = null;
		if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
		{
			//Save the chunk before destroying it
			Serialization.SaveChunk(chunk);

			Object.Destroy(chunk.gameObject);
			chunks.Remove(new WorldPos(x, y, z));
		}
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

		return containerChunk;
	}

	public Block GetBlock(int x, int y, int z)
	{
		Chunk containerChunk = GetChunk(x, y, z);
		if (containerChunk != null)
		{
			Block block = containerChunk.GetBlock(x - containerChunk.pos.x, y -containerChunk.pos.y, z - containerChunk.pos.z);

			return block;
		}
		else
		{
			return new BlockAir();
		}
	}

	public void SetBlock(int x, int y, int z, Block block)
	{
		Chunk chunk = GetChunk(x, y, z);

		if (chunk != null)
		{
			int posX = x - chunk.pos.x;
			int posY = y - chunk.pos.y;
			int posZ = z - chunk.pos.z;

			chunk.SetBlock(posX, posY, posZ, block);
			chunk.update = true;

			//Left and right
			UpdateIfEqual(posX, 0, new WorldPos(x - 1, y, z));
			UpdateIfEqual(posX, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));

			//Up and down
			UpdateIfEqual(posY, 0, new WorldPos(x, y - 1, z));
			UpdateIfEqual(posY, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));

			//Front and behind
			UpdateIfEqual(posZ, 0, new WorldPos(x, y, z - 1));
			UpdateIfEqual(posZ, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
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
