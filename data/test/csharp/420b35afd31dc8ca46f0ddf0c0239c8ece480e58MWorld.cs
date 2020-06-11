using UnityEngine;
using System.Collections;

public class MWorld : ScriptableObject {

	public GameObject[] tilesToUse;

	// Ideal requirements for MWorld

	// Ability to hold the entire gameworld as a series of 'chunks' using the MWorld_Chunk class
	// Ability to load and deload chunks quickly
	// Speed!

	private MWorld_Chunk[,] chunks;
	private int chunkSize;
	private int numChunkX, numChunkY;

	public int[,] tileIDArray;

	// This method initializes the chunks and assigns sizes

	public void initMWorld(int dimX, int dimY, int _chunkSize) {
		Debug.Log ("Initiailizing MWorld...");
		chunks = new MWorld_Chunk[dimX, dimY];
		chunkSize = _chunkSize;
		Debug.Log ("Mworld Initialized!");
		numChunkX = dimX;
		numChunkY = dimY;
	}

	// Initializas all the chunks inside of MWorld within the rae

	public int initChunks(int startX, int startY, int endX, int endY) {

		Debug.Log ("Initialzing starting MWorld Chunk from"+startX+","+startY+" to "+endX+","+endY);

		if (chunks==null) {return 0;}

		for (int i = startX; i <= endX; i++) {
			for (int j = startY; j <= endY; j++) {
				Debug.Log ("");
				Debug.Log ("");
				Debug.Log ("CURXY: " + i + "," + j);
				Debug.Log ("");
				Debug.Log ("");
				initChunk (i,j);
			}
		}

		Debug.Log ("Initialized chunks!");

		return 1;
	}

	public void initChunk(int x, int y) {

		// Initializing each chunk
		Debug.Log("Initializing chunk "+x+","+y);
		MWorld_Chunk tmpChunk = (MWorld_Chunk)MWorld_Chunk.CreateInstance ("MWorld_Chunk");
		tmpChunk.tilesToUse = tilesToUse;
		tmpChunk.totChunksX = numChunkX;
		tmpChunk.totChunksY = numChunkY;
		tmpChunk.initMWorld_Chunk (chunkSize, chunkSize,x,y);
		tmpChunk.initTiles ();
		int terrainType = tileIDArray [x, y];
		Debug.Log ("Setting terrain type at " + x + "," + y + " to " + terrainType);
		tmpChunk.setTerrainType (terrainType);
		Debug.Log ("Just ran setTerrain method...");

		chunks [x, y] = tmpChunk;

	}

	public void spawnCornucopia() {

		for (int i = numChunkX / 2 - 1; i < numChunkX / 2 + 2; i++) {
			for (int j = numChunkY / 2 - 1; j < numChunkY / 2 + 2; j++) {
				spawnChunk (i, j);
			}
		}
	}

	public void spawnChunk(int x, int y) {

		Debug.Log ("Spawning chunk of " + x + "," + y);

		MWorld_Chunk tmpChunk = chunks [x, y];
		tmpChunk.spawnChunk ();
	}

	public void spawnAllChunks() {
		for (int i = 0; i < numChunkX; i++) {
			for (int j = 0; j < numChunkY; j++) {
				spawnChunk (i, j);
			}
		}
	}
}
