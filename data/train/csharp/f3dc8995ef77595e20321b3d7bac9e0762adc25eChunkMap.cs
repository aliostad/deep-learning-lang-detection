using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class ChunkMap
{

	const int chunkOffset = 100;

	[Serializable]
	public class ChunkArray
	{
		[SerializeField]
		public Chunk[] chunks = new Chunk[chunkOffset * 2];
	}

	[SerializeField]
	private ChunkArray[] chunks = new ChunkArray[chunkOffset * 2];
	[SerializeField]
	private List<Chunk> chunkList = new List<Chunk>();

	public List<Chunk> Chunks
	{
		get { return chunkList; }
	}

	public void SetChunk(int x, int y, Chunk chunk)
	{
		if (chunks[x + chunkOffset] == null)
		{
			chunks[x + chunkOffset] = new ChunkArray();
		}
		chunks[x + chunkOffset].chunks[y + chunkOffset] = chunk;
	}

	public Chunk GetChunk(int x, int y)
	{
		if (chunks[x + chunkOffset] == null)
		{
			chunks[x + chunkOffset] = new ChunkArray();
		}
		return chunks[x + chunkOffset].chunks[y + chunkOffset];
	}

	public void Clear()
	{
		foreach (Chunk chunk in chunkList)
		{
			chunk.Dispose();
		}
		chunkList.Clear();
		chunks = new ChunkArray[chunkOffset * 2];
	}

}

