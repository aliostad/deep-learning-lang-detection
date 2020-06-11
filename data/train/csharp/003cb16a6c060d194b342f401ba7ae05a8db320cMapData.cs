using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public static class MapData {

	public static Chunk[,,] Chunks { get { return _chunks; } }

	private static Vector3 CurrentPosition
	{
		get
		{
			return Vector3.zero;
		}
	}

	private const byte CHUNK_RADIUS = 1;

	private static Chunk[,,] _chunks = new Chunk[CHUNK_RADIUS * 2, CHUNK_RADIUS * 2, CHUNK_RADIUS * 2];

	public static void Poll()
	{
		for (int x = 0; x < CHUNK_RADIUS * 2; x++)
		{
			for (int y = 0; y < CHUNK_RADIUS * 2; y++)
			{
				for (int z = 0; z < CHUNK_RADIUS * 2; z++)
				{
					_chunks [x, y, z] = new Chunk(new Vector3(x, y, z));
				}
			}
		}
	}
	public static Chunk GetChunk(int x, int y, int z)
	{
		return GetChunk (new Vector3 (x, y, z));
	}
	public static Chunk GetChunk(Vector3 chunkPosition)
	{
		Vector3 relativeChunkPosition = chunkPosition - CurrentPosition;

		try {
			return _chunks[(byte)relativeChunkPosition.x, (byte)relativeChunkPosition.y, (byte)relativeChunkPosition.z];
		} catch (System.Exception ex) {
			return null;
		}

		if ((byte)relativeChunkPosition.x > _chunks.GetLowerBound(0) && (byte)relativeChunkPosition.x < _chunks.GetUpperBound(0) &&
			(byte)relativeChunkPosition.y > _chunks.GetLowerBound(1) && (byte)relativeChunkPosition.y < _chunks.GetUpperBound(1) &&
			(byte)relativeChunkPosition.z > _chunks.GetLowerBound(2) && (byte)relativeChunkPosition.z < _chunks.GetUpperBound(2))
		{
			return _chunks[(byte)relativeChunkPosition.x, (byte)relativeChunkPosition.y, (byte)relativeChunkPosition.z];
		}

		Debug.LogWarning("Couldn't return " + relativeChunkPosition);

		return null;
	}
}