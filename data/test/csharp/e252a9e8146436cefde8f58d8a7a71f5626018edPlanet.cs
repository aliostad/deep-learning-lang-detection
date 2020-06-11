using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Planet : MonoBehaviour {

	public static int worldSize = 8;
	public GameObject chunkPrefab;
	public Dictionary<Vector3, Chunk> chunks = new Dictionary<Vector3, Chunk>(); 
	public ThreadManager manager;

	// Use this for initialization
	void Start () {
		int threads = SystemInfo.processorCount - 2;
		manager = new ThreadManager (4);

		for (int x=-worldSize; x<worldSize; x++){
			for (int y=-worldSize; y<worldSize; y++){
				for (int z=-worldSize; z<worldSize; z++){
					CreateChunk(x*Chunk.size, y*Chunk.size, z*Chunk.size);
				}
			}
		}

		//CreateChunk (0, 0, 0);
	}
	
	// Update is called once per frame
	void Update () {

		if (Input.GetButtonDown ("Fire1")) {
			manager.Clear();
		}

		if (Input.GetButtonDown ("Fire2")) {
			Debug.Log ("Coda: "+manager.GetWaitingThreads());
			Debug.Log("Processi attivi: "+manager.GetRunningThreads());
		}
	}

	public void CreateChunk(int x, int y, int z){
		Vector3 chunkPos = new Vector3 (x, y, z);

		GameObject newChunkObject = Instantiate(chunkPrefab, Vector3.zero, Quaternion.Euler(Vector3.zero)) as GameObject;
		newChunkObject.transform.parent = this.transform;
		Chunk newChunk = newChunkObject.GetComponent<Chunk> ();

		newChunk.pos = chunkPos;
		newChunk.planet = this;
		newChunk.manager = this.manager;
		chunks.Add (chunkPos, newChunk);
	}

	public Chunk GetChunk(Vector3 position){
		int x = (Mathf.FloorToInt (position.x / Chunk.size)) * Chunk.size;
		int y = (Mathf.FloorToInt (position.y / Chunk.size)) * Chunk.size;
		int z = (Mathf.FloorToInt (position.z / Chunk.size)) * Chunk.size;

		Vector3 pos = new Vector3 (x, y, z);
		Chunk container;
		if (chunks.TryGetValue (pos, out container))
			return container;
		else
			return null;
	}
}
