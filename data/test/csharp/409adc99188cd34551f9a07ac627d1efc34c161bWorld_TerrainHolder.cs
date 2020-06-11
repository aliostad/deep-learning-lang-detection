using UnityEngine;
using System.Collections;

public class World_TerrainHolder : MonoBehaviour {

	// Instance Fields
	// NEEDS to hold an integer 2D array named terrain[,] containing the tileIDs for co-ordinates
	// Should also contain a link to the WorldGen script, in order to properly generate terrain...

	// Role

	// Holds all the Terrain information in the map

	public bool isValid = false;

	public static short [,] terrain;
	public static short [,] terrainCost;

	public static short [,] chunkTerrain;

	private static short chunkSize, numChunks, terrainType;

	private static int sizeX, sizeY;

	private static World_ChunkGenerator wg;

	void Awake() {
		DontDestroyOnLoad (this);
		terrainType = 0;
	}

	public void setData(short _chunkSize, short _numChunks, short _terrainType) {

		// Assiggns all the important information before generation
		chunkSize = _chunkSize;
		numChunks = _numChunks;
		terrainType = _terrainType;
		sizeX = chunkSize * numChunks;
		sizeY = sizeX;
	}

	public void generateWorld() {

		// All this method does is, essentially, initialize the world to contain all zeroes. Does not actually use world gen
		
		terrain = new short[sizeX, sizeY];
		terrainCost = new short[sizeX, sizeY];

		for (int i = 0; i < sizeX; i++) {
			for (int j = 0; j < sizeY; j++) {
				terrain [i, j] = 0;
				terrainCost [i, j] = 1;
			}
		}

		Debug.Log ("Initialized the world... NumChunks: "+numChunks+", ChunkSize: "+chunkSize);
		isValid = true;
	}


	public void worldGenWorld() {


		// Generates the chunk map for the world

		wg = new World_ChunkGenerator (numChunks, terrainType, chunkSize);
		wg.generate ();

		chunkTerrain = wg.getChunkTerrain ();

	}

	public void loadChunk(int chunkX, int chunkY) {

		// Fill in actually spawning the chunks for this area

		int startX = chunkX * chunkSize;
		int startY = chunkY * chunkSize;

		int stopX = chunkX * chunkSize + chunkSize - 1;
		int stopY = chunkY * chunkSize + chunkSize - 1;

		for (int i = startX; i <= stopX; i++) {
			for (int j = startY; j <= stopY; j++) {

			}
		}
	}

	public int copyInChunk(int chunkX, int chunkY, short[,] chunk) {
		//Debug.Log ("Copying in chunk...");
		//Debug.Log (terrain.GetLength (0) + "," + terrain.GetLength (1));
		for (int i = 0; i < chunkSize; i++) {
			for (int j = 0; j < chunkSize; j++) {
				//Debug.Log ((chunkX*chunkSize+i) + "," + (chunkY*chunkSize+j));
				terrain [chunkX * chunkSize + i, chunkY * chunkSize + j] = chunk [i, j];
			}
		}

		return 1;
	}

	public short[,] copyOutChunk(int chunkX, int chunkY) {

		short[,] returnChunk = new short[chunkSize, chunkSize];

		for (int i = 0; i < chunkSize; i++) {
			for (int j = 0; j < chunkSize; j++) {
				returnChunk [i, j] = terrain [chunkX * chunkSize + i, chunkY * chunkSize + j];
			}
		}

		return returnChunk;
	}

	public void loadSpawn() {

	}

	public short[,] getChunkTerrain() {
		return chunkTerrain;
	}

	public short[,] getTerrain() {
		return terrain;
	}

	public short[,] getTerrainCost() {
		return terrainCost;
	}

	public short getChunkSize() {
		return chunkSize;
	}
}
