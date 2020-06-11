using UnityEngine;
using System.Collections;
using System.Collections.Generic;
// Code from http://www.raywenderlich.com/69392/make-game-like-jetpack-joyride-unity-2d-part-1

public class GenerateEndlessLevel : MonoBehaviour {
	public GameObject[] availableChunks;
	public int[] chunkSpawnChances;
	public List<GameObject> currentChunks;
	private float screenWidthInPoints;

	// Use this for initialization
	void Start () {
		// Get references to all the chunks
		float height = 2.0f * Camera.main.orthographicSize;
		screenWidthInPoints = height * Camera.main.aspect;
	}
	
	void FixedUpdate () {
		GenerateChunkIfRequired();
	}

	public void AddChunk(float FarthestChunkEndX) {
		int randomChunkIndex = Random.Range(0, chunkSpawnChances.Length);

		GameObject chunk = (GameObject)Instantiate(availableChunks[chunkSpawnChances[randomChunkIndex]]);

		float chunkWidth = chunk.transform.FindChild("void").localScale.x;

		float chunkCenter = FarthestChunkEndX + chunkWidth * 0.5f;

		chunk.transform.position = new Vector3(chunkCenter, 0, 0);

		currentChunks.Add(chunk);
	}

	void GenerateChunkIfRequired() {
		List<GameObject> chunksToRemove = new List<GameObject>();

		bool addChunks = true;        

		float playerX = transform.position.x;

		float removeChunkX = playerX - screenWidthInPoints;        

		float addChunkX = playerX + screenWidthInPoints;

		float farthestChunkEndX = 0;
		
		foreach(var chunk in currentChunks) {
			float chunkWidth = chunk.transform.FindChild("void").localScale.x;
			float chunkStartX = chunk.transform.position.x - (chunkWidth * 0.5f);    
			float chunkEndX = chunkStartX + chunkWidth;                            

			if (chunkStartX > addChunkX) {
				addChunks = false;
			}

			if (chunkEndX < removeChunkX) {
				chunksToRemove.Add(chunk);
			}

			farthestChunkEndX = Mathf.Max(farthestChunkEndX, chunkEndX);
		}

		foreach(var chunk in chunksToRemove) {
			currentChunks.Remove(chunk);
			Destroy(chunk);            
		}

		if (addChunks) {
			AddChunk (farthestChunkEndX);
		}
	}
}