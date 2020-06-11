using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public struct ChunkCoord
{
	public int coordX;
	public int coordY;
}

public class ChunkLoader : MonoBehaviour {
	public const int viewDistance = 800;
	public int visibleChunks;
	public Transform player;
	public MapGenerator generator;
	public Material materail;

	protected Vector2 playerPos;
	protected IHeightmapGenerator mapGenerator;

	Dictionary<ChunkCoord, Chunk> chunks = new Dictionary<ChunkCoord, Chunk>();
	protected float h_sqrt_3 = Mathf.Sqrt(3.0f) * 0.5f;

	// Use this for initialization
	void Start () {
		mapGenerator = generator.createGenerator();
		visibleChunks = viewDistance / Chunk.size + 1; /* sometimes when the player is near an edge an extra chunk is loaded */
	}
	
	// Update is called once per frame
	void Update () {
		//get player pos
		playerPos = new Vector2(player.position.x, player.position.z);
		List<ChunkCoord> removeKeys = new List<ChunkCoord>();

		// remove the chunks that are out of the view distance 
		foreach (KeyValuePair<ChunkCoord, Chunk> chunk in chunks)
		{
			Vector2 center = chunk.Value.getCenter();
			if (distanceChunkToPlayer(center) > viewDistance)
			{
				chunk.Value.visible(0, false, false, false, false);
				removeKeys.Add(chunk.Key);
				Destroy(chunk.Value.getObject());
			}
		}

		foreach(ChunkCoord key in removeKeys)
		{
			chunks.Remove(key);
		}

		//get the coordinates of the chunk the player is on
		ChunkCoord playerChunk = getChunkCoord(playerPos);
		float f_centerX = ((float)playerChunk.coordX) * Chunk.size;
		float f_centerY = ((float)playerChunk.coordY) * Chunk.size * h_sqrt_3;
	
		//render the chunks
		for (int x = -visibleChunks; x <= visibleChunks; x++)
		{
			for (int y = -visibleChunks; y <= visibleChunks; y++)
			{
				
				Vector2 chunkCenter = new Vector2(f_centerX + (x * Chunk.size - 0), f_centerY + y * Chunk.size * h_sqrt_3);
				
				loadChunk(chunkCenter);
			}
		}
	}

	/**
	 * Render the chunk at the position chunkCenter.
	 */
	protected void loadChunk(Vector2 chunkCenter)
	{
		Chunk chunk;
		int details = getDetails(chunkCenter);
		ChunkCoord chunkCoord = getChunkCoord(chunkCenter);
		
		if (details == 0)
		{
			return;
		}

		//if the chunk does not exist, create the chunk
		if (!chunks.TryGetValue(chunkCoord, out chunk))
		{
			chunk = new Chunk(chunkCenter, mapGenerator, materail);
			chunks.Add(chunkCoord, chunk);
		}

		//check the levelOfDetail of the chunks that are connected to this chunk
		bool lowResTop = getDetails(new Vector2(chunkCenter.x, chunkCenter.y + Chunk.size * h_sqrt_3)) > details;
		bool lowResBottom = getDetails(new Vector2(chunkCenter.x, chunkCenter.y - Chunk.size * h_sqrt_3)) > details;
		bool lowResLeft = getDetails(new Vector2(chunkCenter.x - Chunk.size, chunkCenter.y)) > details;
		bool lowResRight = getDetails(new Vector2(chunkCenter.x + Chunk.size, chunkCenter.y)) > details;

		chunk.visible(details, lowResTop, lowResRight, lowResBottom, lowResLeft);
	}

	/**
	 * Get the distance from this chunk to the player.
	 */
	protected float distanceChunkToPlayer(Vector2 chunkCenter)
	{
		float diffX = 0.5f * Chunk.size;
		float closestX = (chunkCenter.x + diffX < playerPos.x) ? chunkCenter.x + diffX :
			(chunkCenter.x - diffX > playerPos.x) ? chunkCenter.x - diffX : playerPos.x;

		float diffY = 0.5f * Chunk.size * h_sqrt_3;
		float closestY = (chunkCenter.y + diffY < playerPos.y) ? chunkCenter.y + diffY :
			(chunkCenter.y - diffY > playerPos.y) ? chunkCenter.y - diffY : playerPos.y;

		return Vector2.Distance(playerPos, new Vector2(closestX, closestY));
	}

	/**
	 * Convert the center coord to chunk coords.
	 */
	protected ChunkCoord getChunkCoord(Vector2 coord)
	{
		ChunkCoord chunkCoord;
		float f_coordX = coord.x / (float)Chunk.size;
		float f_coordY = coord.y / (((float)Chunk.size) * h_sqrt_3);
		chunkCoord.coordX = (f_coordX > 0) ? Mathf.FloorToInt(f_coordX) : Mathf.CeilToInt(f_coordX);
		chunkCoord.coordY = (f_coordY > 0) ? Mathf.FloorToInt(f_coordY) : Mathf.CeilToInt(f_coordY);
		return chunkCoord;
	}

	protected int getDetails(Vector2 chunkCenter)
	{
		float distance = distanceChunkToPlayer(chunkCenter);
		float increasedDistance = distance + 3 * Chunk.size / 4;
		int details = (int)increasedDistance / Chunk.size + 1;
		details = (distance > viewDistance) ? 0 : details;
		return details;
	}
}
