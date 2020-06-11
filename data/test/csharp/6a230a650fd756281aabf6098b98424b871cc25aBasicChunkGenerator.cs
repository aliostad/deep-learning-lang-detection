using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using o2dtk.TileMap;
using o2dtk.Collections;

public class BasicChunkGenerator : TileMapChunkGenerator
{
	[System.Serializable]
	public class ChunkMap : Map<IPair, TileChunk>
	{ }

	public ChunkMap chunks;

	public void OnEnable()
	{
		chunks = new ChunkMap();
	}
	public override TileChunk GetChunk(TileMap tile_map, int pos_x, int pos_y)
	{
		IPair index = new IPair(pos_x, pos_y);

		if (!chunks.ContainsKey(index))
		{
			TileChunk chunk = ScriptableObject.CreateInstance<TileChunk>();

			chunk.index_x = pos_x;
			chunk.index_y = pos_y;
			chunk.pos_x = pos_x * tile_map.chunk_size_x;
			chunk.pos_y = pos_y * tile_map.chunk_size_y;
			chunk.size_x = tile_map.chunk_size_x;
			chunk.size_y = tile_map.chunk_size_y;

			TileChunkDataLayer data_layer = new TileChunkDataLayer(chunk.size_x, chunk.size_y);

			for (int i = 0; i < chunk.size_x * chunk.size_y; ++i)
				data_layer.ids[i] = (Random.value >= 0.5f ? 1 : 0);

			chunk.data_layers = new List<TileChunkDataLayer>();
			chunk.user_data = new List<ScriptableObject>();

			chunk.data_layers.Add(data_layer);

			chunks.Add(index, chunk);
		}

		return chunks[index];
	}
}
