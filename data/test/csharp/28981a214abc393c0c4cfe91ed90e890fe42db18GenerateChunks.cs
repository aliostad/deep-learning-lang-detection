using UnityEngine;
using System.Collections;

public class GenerateChunks : MonoBehaviour {

	public GameObject chunk;
	int chunkWidth;
	public int numChunks;
	float seed;

	void Start () {
		chunkWidth = chunk.GetComponent<GenerateChunk> ().width;
		seed = Random.Range (-100000f, 100000f);
		Generate ();
	}

	public void Generate () {
		int lastX = -chunkWidth;
		for (int i = 0; i < numChunks; i++) {
			GameObject newChunk = Instantiate(chunk, new Vector3(lastX + chunkWidth, 0f), Quaternion.identity) as GameObject;
			newChunk.GetComponent<GenerateChunk> ().seed = seed;
			lastX += chunkWidth;
		}
	}
}
