using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class IslandGenerator : Generator {

	public int _islandSizeX = 100;
	public int _islandSizeY = 100;
  public int _maxHeight = 100;

	public override ChunkData Generate(WorldPos chunkPos) {
		ChunkData chunkData;
		if (!chunkDatas.TryGetValue(chunkPos, out chunkData))
		{
			chunkData = new ChunkData(_chunkSize);

			for (int xi = 0; xi < _chunkSize; xi++)
			{
				for (int zi = 0; zi < _chunkSize; zi++)
				{
          Vector2 pos = new Vector2(_chunkSize * chunkPos.x + xi, _chunkSize * chunkPos.z + zi);
          float multiplier = 1-(Vector2.Distance(pos, new Vector2(_islandSizeX/2 * _chunkSize, _islandSizeY/2 * _chunkSize)) /
                            Vector2.Distance(new Vector2(0, _islandSizeY/2 * _chunkSize), new Vector2(_islandSizeX/2 * _chunkSize, _islandSizeY/2 * _chunkSize)));
          float height = Mathf.PerlinNoise(pos.x/(float)(_islandSizeX), pos.y/(float)(_islandSizeY)) * multiplier * _maxHeight;

          chunkData._heightMap[xi, zi] = height;
				}
			}
      
      chunkDatas.Add(chunkPos, chunkData);
		}

		return chunkData;
	}
}
