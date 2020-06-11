using UnityEngine;
using System.Collections;
public class Generator : MonoBehaviour 	{
	private static ChunkLoader chunkLoader;
	private Biome currentBiome;

	public static int[,] generateChunkAsNumbers(int chunkOffset) {
		if (chunkLoader==null) chunkLoader=GameObject.Find("ChunkLoader").GetComponent<ChunkLoader>();
		int[,] toReturn=new int[chunkLoader.CHUNK_WIDTH, chunkLoader.MAX_SKY_HEIGHT-chunkLoader.BEDROCK_LEVEL];
		int surfaceLevel=toReturn.GetLength(1)/2;
		for (int x=0; x<toReturn.GetLength(0); x++) {
			generateLayer(x, surfaceLevel, 5, toReturn);
		}
		return toReturn;
	}
	
	private static void generateLayer(int x, int startingHeight, int grassHeight, int[,] chunk) {
		for (int y=0; y<chunk.GetLength(1); y++) {
			if (y>startingHeight)chunk[x, y]=Chunk.AIR_CODE;
			if (y==startingHeight)chunk[x, y]=Chunk.GRASS_CODE;
			if (y<startingHeight&&y>=startingHeight-grassHeight) chunk[x, y]=Chunk.DIRT_CODE;
			if (y<startingHeight-grassHeight)chunk[x, y]=Chunk.STONE_CODE;
		}
	}
}

