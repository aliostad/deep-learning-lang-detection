using UnityEngine;
using System.Collections;
using PerlinNoiseProject;
using MarchingCubesProject;

public class TerrainGenerator : MonoBehaviour {

	ChunkManager chunkManager;
	GameObject 	 player;
	Vector3		 playerPosition;
	public Vector3		 currentChunk;
	Vector3		 lastChunk = -Vector3.one;


	void Start () {
		Application.targetFrameRate = 30;
		player = GameObject.Find ("Player").gameObject;
		chunkManager = GameObject.FindObjectOfType<ChunkManager>();
		GetCurrentChunk ();
		chunkManager.updateVisibleChunks(currentChunk);

	}

	void Update() {
		GetCurrentChunk ();
		if (currentChunk != lastChunk) {

			lastChunk = currentChunk;
			// Determine what chunks need to be rendered.
			chunkManager.updateVisibleChunks(currentChunk);

		}
	}

	void GetCurrentChunk() {
		playerPosition = player.transform.position;
		// Determine in what chunk the player currently is.
		currentChunk = playerPosition;
		currentChunk.x = Mathf.RoundToInt (currentChunk.x / 32);
		currentChunk.y = Mathf.RoundToInt (currentChunk.y / 32);
		currentChunk.z = Mathf.RoundToInt (currentChunk.z / 32);
	}

}
