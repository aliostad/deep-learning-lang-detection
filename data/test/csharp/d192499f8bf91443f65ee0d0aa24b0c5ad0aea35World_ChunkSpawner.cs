using UnityEngine;
using System.Collections;

public class World_ChunkSpawner : MonoBehaviour {

	private short[,] chunks;
	private int chunkSize;
	private GameObject[] tilesToUse;

	public void initialize(short[,] _chunks, GameObject[] _tilesToUse, int _chunkSize) {
		tilesToUse = _tilesToUse;
		chunks = _chunks;
		chunkSize = _chunkSize;
	}

	public short[,] spawnChunk(short chunkX, short chunkY) {
		//Debug.Log ("Spawning chunk at " + chunkX + "," + chunkY);

		short chunkType = chunks [chunkX, chunkY];
		short[,] returnChunk = new short[chunkSize, chunkSize];

		for (int i = 0; i < chunkSize; i++) {
			for (int j = 0; j < chunkSize; j++) {
				returnChunk [i, j] = chunkType;
			}
		}

		return returnChunk;
	}
}
