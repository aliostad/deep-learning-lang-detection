using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using VoxelWorld.Terrain;

namespace VoxelWorld.Data
{

[Serializable]
/**
 * Serial data container for chunk data.
 */
public class ChunkSerialized
{
	public byte[ , , ] blocks = new byte[Chunk.chunkSize, Chunk.chunkSize, Chunk.chunkSize];
	public byte[ , , ] meta = new byte[Chunk.chunkSize, Chunk.chunkSize, Chunk.chunkSize];
	[NonSerialized]
	public bool empty = false;

	public ChunkSerialized(Chunk chunk)
	{
		if(chunk == null || chunk.empty == true){empty = true; return;}

		for(int x = 0; x < Chunk.chunkSize; x++)
		{
			for(int y = 0; y < Chunk.chunkSize; y++)
			{
				for(int z = 0; z < Chunk.chunkSize; z++)
				{
					blocks[x, y, z] = chunk.blocks[x, y, z];
					meta[x, y, z] = chunk.meta[x, y, z];
				}
			}
		}
	}
}

}