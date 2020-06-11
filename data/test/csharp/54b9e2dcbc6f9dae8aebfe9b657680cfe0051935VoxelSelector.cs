using System.Collections.Generic;
using UnityEngine;

internal class VoxelSelector
{
	private static Dictionary<Vector3, Chunk> _loadedChunks;

	public static void SetLoadedChunks(Dictionary<Vector3, Chunk> loadedChunks)
	{
		_loadedChunks = loadedChunks;
	}

	public static Voxel SelectVoxel(Vector3 chunkCoord, int x, int y, int z)
	{
		if(x < 0) { chunkCoord.x--; x += (int)Chunk.ChunkSize.x; }
		if(y < 0) { chunkCoord.y--; y += (int)Chunk.ChunkSize.y; }
		if(z < 0) { chunkCoord.z--; z += (int)Chunk.ChunkSize.z; }

		if(x >= Chunk.ChunkSize.x) { chunkCoord.x++; x -= (int)Chunk.ChunkSize.x; }
		if(y >= Chunk.ChunkSize.y) { chunkCoord.y++; y -= (int)Chunk.ChunkSize.y; }
		if(z >= Chunk.ChunkSize.z) { chunkCoord.z++; z -= (int)Chunk.ChunkSize.z; }

		Chunk chunk = null;
		Voxel voxel = new Voxel();
		//Debug.Log("chunk coords" + chunkCoord);
		//Debug.Log("voxel coords " + x + "," + y + "," + z);

		if(_loadedChunks.TryGetValue(chunkCoord, out chunk))
		{
			voxel = chunk.VoxelAt(x, y, z);
		}
		else
		{
			voxel.on = false;
		}

		return voxel;
	}

	public static bool SelectVoxelValue(Vector3 chunkCoord, int x, int y, int z)
	{
		return SelectVoxel(chunkCoord, x, y, z).on;
	}
}
