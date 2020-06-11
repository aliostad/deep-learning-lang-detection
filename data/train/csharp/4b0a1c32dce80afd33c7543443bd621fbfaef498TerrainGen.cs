using UnityEngine;
using System.Collections;
using SimplexNoise;

public class TerrainGen {

	public Chunk Chunk_Gen(Chunk chunk) {
		for(int x = chunk.pos.x; x < chunk.pos.x + Chunk.chunk_size; ++x) {
			for(int y = chunk.pos.y; y < chunk.pos.y + Chunk.chunk_size; ++y) {
				chunk = Chunk_Column_Gen(chunk, x, y);
			}
		}
		return chunk;
	}
	
	public Chunk Chunk_Column_Gen(Chunk chunk, int x, int y) {	
		int block_value = Get_Noise(x, y, 0, 0.04f, 2);	
		if(block_value == 0) {
			chunk.Set_Block(x - chunk.pos.x, y - chunk.pos.y, 0, new GrassFlower());
		} else {
			chunk.Set_Block(x - chunk.pos.x, y - chunk.pos.y, 0, new CenterGrass());
		}				
		return chunk;
	}
	
	public static int Get_Noise(int x, int y, int z, float scale, int max) {
		return Mathf.FloorToInt((Noise.Generate(x * scale, y * scale, z) + 1f) * (max/2f));
	}
}
