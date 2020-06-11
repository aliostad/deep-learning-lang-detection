using UnityEngine;
using System.Collections;
public class ChunkLoader : MonoBehaviour {
	public int BEDROCK_LEVEL=-200, MAX_SKY_HEIGHT=100, CHUNK_WIDTH=50;
	public int MAX_SURFACE_LEVEL=50, MIN_SURFACE_LEVEL=-100;
	private ArrayList chunks=new ArrayList();
	public Block[] blockPrefabs;
	public Chunk chunkPrefab;
	
	void Start() {
		generateChunk(0);
		generateChunk(-1);
	}
	
	public Chunk getChunk(int offset) {
		foreach (Chunk c in chunks)
			if (c.getChunkOffset()==offset) return c;
		generateChunk(offset);
		return getChunk(offset);
	}

	
	private void generateChunk(int chunkOffset) {
		int[,] numbers=Generator.generateChunkAsNumbers(chunkOffset);
		Chunk chunk=Chunk.ToRealChunk(numbers, chunkOffset);
		chunks.Add(chunk);
	}
}
