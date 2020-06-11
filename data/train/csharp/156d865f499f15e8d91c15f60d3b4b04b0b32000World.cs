using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using VoxelWorld.Rendering;
using VoxelWorld.Terrain.Generation;
using VoxelWorld.IO;

namespace VoxelWorld.Terrain
{

/**
 * World containing chunks of terrain.
 */
public class World : MonoBehaviour
{
	/** Dictionary of all the chunks in this world. */
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
	/** Universal prefab for the structure of a single chunk. */
	public GameObject chunkPrefab;
	/** The current terrain noise used. */
	public Noise noise;
	/** Terrain generator handling the creation of terrain. */
	public TerrainGen terrainGen;

	/** Name of this world. */
	public string worldName = "world";

	private void Awake()
	{
		//Change application settings.
		Application.targetFrameRate = 60;
		Cursor.visible = false;
		//Load all blocks.
		new BlockList();
		//Start the terrain generator.
		noise = new Noise();
		terrainGen = new TerrainGen(noise);
	}

	private void OnApplicationQuit()
	{
		foreach(KeyValuePair<WorldPos, Chunk> chunk in chunks)
		{
			if(!chunk.Value.needsSaving){continue;}

			FileManager.SaveChunk(chunk.Value);
		}
	}

	/**
	 * Creates a new chunk at the given world position.
	 */
	public void CreateChunk(WorldPos pos)
	{
		Chunk chunk = new Chunk();

		chunk.pos = pos;
		chunk.world = this;

		chunks.Add(pos, chunk);

		if(!FileManager.LoadChunk(chunk))
		{
			chunk = terrainGen.ChunkGen(chunk);
			MakePhysical(chunk);
			return;
		}

		chunk.empty = IsChunkEmpty(chunk);
		MakePhysical(chunk);
	}

	/**
	 * Create a chunk at the given coords.
	 */
	public void CreateChunk(int x, int y, int z)
	{
		CreateChunk(new WorldPos(x, y, z));
	}

	/**
	 * Create a new GameObject with a ChunkRenderer component
	 * and link it to the given chunk chunk.
	 * Returns false if the chunk is empty. In that case
	 * no visual chunk will be generated.
	 */
	bool MakePhysical(Chunk chunk)
	{
		if(!chunk.empty)
		{
			Vector3 newPos = new Vector3(chunk.pos.x, chunk.pos.y, chunk.pos.z);
			GameObject newRenderer = Instantiate(chunkPrefab, newPos, Quaternion.Euler(Vector3.zero)) as GameObject;
			ChunkRenderer renderer = newRenderer.GetComponent<ChunkRenderer>();
			renderer.chunk = chunk;
			chunk.renderer = renderer;
			newRenderer.name = "Chunk (" + chunk.pos.x + ", " + chunk.pos.y + ", " + chunk.pos.z + ")";
			newRenderer.transform.parent = gameObject.transform;
			return true;
		}
		return false;
	}

	/**
	 * Get the chunk holding chunk at the given coords.
	 */
	public Chunk GetChunk(int x, int y, int z)
	{
		WorldPos pos = new WorldPos();
		float multiple = Chunk.chunkSize;
		pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize;
		pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize;
		pos.z = Mathf.FloorToInt(z / multiple) * Chunk.chunkSize;

		Chunk chunk = null;

		chunks.TryGetValue(pos, out chunk);

		return chunk;
	}

	/**
	 * Destroy the chunk at the given coords.
	 */
	public void DestroyChunk(int x, int y, int z)
	{
		Chunk chunk = null;
		if(chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
		{
			FileManager.SaveChunk(chunk);
			if(chunk.renderer != null)
			{
				Object.Destroy(chunk.renderer.gameObject);
			}
			chunks.Remove(new WorldPos(x, y, z));
		}
	}

	/**
	 * Get the block at the given coords. Returns BlockAir if null.
	 */
	public int GetBlock(int x, int y, int z)
	{
		Chunk chunk = GetChunk(x, y, z);

		if(chunk != null)
		{
			int block = chunk.GetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z);

			return block;
		}
		else
		{
			return 0;
		}
	}

	/**
	 * Set the block at the given coords.
	 * Also updates neighbor chunks if an edge block is changed.
	 */
	public void SetBlock(int x, int y, int z, int id)
	{
		Chunk chunk = GetChunk(x, y, z);

		if(chunk != null)
		{
			chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, id);

			if(chunk.empty && !IsChunkEmpty(chunk))
			{
				chunk.empty = false;
				if(MakePhysical(chunk))
				{
					chunk.update = true;
				}
			}
			else
			{
				chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, id);
				chunk.update = true;
			}

			UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
			UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
			UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
			UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
			UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
			UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
		}
	}

	/**
	 * Is this chunk empty? (Only contains air.)
	 */
	public bool IsChunkEmpty(Chunk chunk)
	{
		foreach(byte block in chunk.blocks)
		{
			if(block > 0)
			{
				return false;
			}
		}

		return true;
	}

	/**
	 * Rounds a given Vector3 to the coords of a potential block.
	 */
	public static WorldPos GetBlockPos(Vector3 pos)
	{
		WorldPos blockPos = new WorldPos(Mathf.RoundToInt(pos.x), Mathf.RoundToInt(pos.y), Mathf.RoundToInt(pos.z));

		return blockPos;
	}

	/**
	 * Gets the block postion of the block hit by the raycast.
	 * If adjecent is true then it returns the block that is adjecent to the surface hit.
	 */
	public static WorldPos GetBlockPos(RaycastHit hit, bool adjecent = false)
	{
		Vector3 pos = new Vector3();
		pos.x = MoveWithinBlock(hit.point.x, hit.normal.x, adjecent);
		pos.y = MoveWithinBlock(hit.point.y, hit.normal.y, adjecent);
		pos.z = MoveWithinBlock(hit.point.z, hit.normal.z, adjecent);

		return GetBlockPos(pos);
	}

	/**
	 * Check if the point provided is within the boundaries of the block hit or the
	 * adjacent one.
	 */
	private static float MoveWithinBlock(float pos, float norm, bool adjecent = false)
	{
		if(pos - (int)pos == 0.5f || pos - (int)pos == -0.5f)
		{
			if(adjecent)
			{
				pos += (norm / 2);
			}
			else
			{
				pos -= (norm / 2);
			}
		}

		return (float)pos;
	}

	/**
	 * Sets the block where the raycast hits and returns true.
	 * Returns false if no block was found to be set.
	 */
	public static bool SetBlock(RaycastHit hit, int id, bool adjacent = false)
	{
		ChunkRenderer renderer = hit.collider.GetComponent<ChunkRenderer>();
		if(renderer == null){return false;}

		WorldPos pos = GetBlockPos(hit, adjacent);

		renderer.chunk.world.SetBlock(pos.x, pos.y, pos.z, id);

		return true;
	}

	/**
	 * Returns the block where the raycast hits.
	 * Returns 0(air) if no block was found.
	 */
	public static int GetBlock(RaycastHit hit, bool adjacent = false)
	{
		ChunkRenderer renderer = hit.collider.GetComponent<ChunkRenderer>();
		if(renderer == null){return 0;}

		WorldPos pos = GetBlockPos(hit, adjacent);

		int block = renderer.chunk.world.GetBlock(pos.x, pos.y, pos.z);

		return block;
	}

	/**
	 * Set a chunk at the given WorldPos to update if the two given values match.
	 */
	private void UpdateIfEqual(int valueOne, int valueTwo, WorldPos pos)
	{
		if(valueOne == valueTwo)
		{
			Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
			if(chunk != null)
			{
				chunk.update = true;
			}
		}
	}
}

}