using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {

	public const int CHUNKSIZE = 16;
	public const int WORLDSIZE = 3;

	public static Dictionary<Vector3, Chunk> chunks = new Dictionary<Vector3, Chunk>();
	public List<Chunk> chunksToUpdate = new List<Chunk>();

	public GameObject chunkPrefab;

	void Start () 
	{
		StartCoroutine ("TestGeneration");
	}

	IEnumerator TestGeneration() 
	{
		for(int dist = 0;dist<WORLDSIZE;dist++) {
			yield return new WaitForSeconds (1);

			if(dist == 0) {
				addChunk (0, 0);
				continue;
			}

			yield return new WaitForSeconds (1);
			for(int x=-dist;x<=dist;x++) {
				addChunk (x, dist);
			}

			yield return new WaitForSeconds (1);
			for(int y=dist-1;y>-dist;y--) {
				addChunk (dist, y);
			}

			yield return new WaitForSeconds (1);
			for(int x=dist;x>=-dist;x--) {
				addChunk (x, -dist);
			}
				
			yield return new WaitForSeconds (1);
			for(int y=-dist+1;y<dist;y++) {
				addChunk (-dist, y);
			}
		}
	}

	public void addChunk(int x, int z) 
	{
		Vector3 chunkPos = new Vector3 (x * CHUNKSIZE, 0, z * CHUNKSIZE);
		GameObject chunkObject = (GameObject) Instantiate (chunkPrefab, chunkPos, Quaternion.identity);
		chunkObject.transform.name = "[" + x + "," + z + "]";
		Chunk chunk = chunkObject.GetComponent<Chunk> ();
		chunksToUpdate.Add (chunk);
		chunks.Add(chunkPos, chunk);
	}
		
	public static Chunk getChunk(Vector3 pos) 
	{
		Vector3 floorPos = new Vector3 (Mathf.Floor (pos.x), Mathf.Floor (pos.y), Mathf.Floor (pos.z));
		int chunkXPos =  (int) Mathf.Floor(floorPos.x / CHUNKSIZE) * CHUNKSIZE;
		int chunkZPos =  (int) Mathf.Floor(floorPos.z / CHUNKSIZE) * CHUNKSIZE;
		Vector3 chunkPos = new Vector3 (chunkXPos, 0, chunkZPos);

		if(chunks.ContainsKey(chunkPos)) {
			return chunks [chunkPos];
		} else {
			return null;
		}
	}

	public static Block getBlock(Vector3 pos) 
	{
		Vector3 floorPos = new Vector3 (Mathf.Floor (pos.x), Mathf.Floor (pos.y), Mathf.Floor (pos.z));
		Chunk chunk = getChunk (floorPos);

		if(chunk != null) {
			Vector3 blockPos;
			blockPos.x = floorPos.x - chunk._chunkPos.x;
			blockPos.y = floorPos.y - chunk._chunkPos.y;
			blockPos.z = floorPos.z - chunk._chunkPos.z;

			return chunk.getBlock ((int)blockPos.x, (int)blockPos.y, (int)blockPos.z);
		} else {
			return new AirBlock ();
		}
	}
		
}
