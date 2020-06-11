using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkManager : MonoBehaviour {

	public GameObject[] chunks;
	public GameObject chunkParent;
	GameObject alertManager;
	float nextChunkPos;
	int randomInt;
	Vector3 chunkSpot;

	int rotInt;
	Quaternion[] chunkRot;
	public List<GameObject> chunkList;

	void Awake () {
		alertManager = GameObject.Find("AlertManager");
		nextChunkPos = chunks[0].GetComponent<BoxCollider>().size.y;

		chunkRot = new Quaternion[4];
		chunkRot[0] = Quaternion.Euler(0, 0, 0);
		chunkRot[1] = Quaternion.Euler(0, 0, 90);
		chunkRot[2] = Quaternion.Euler(0, 0, 180);
		chunkRot[3] = Quaternion.Euler(0, 0, 270);


		for (int i = 0; i < 3; i++) {
			randomInt = (int)Random.Range(0, chunks.Length);
			chunkSpot += new Vector3(0, nextChunkPos, 0);
			GameObject chunkIns = (GameObject)Instantiate(chunks[randomInt], chunkSpot, new Quaternion(0, 0, 0, 0));
			chunkIns.transform.parent = chunkParent.transform;
			chunkList.Add(chunkIns);
		}
	}

	public void SpawnChunk () {

		rotInt = (int)Random.Range(0, 4);																//Randomizes the rotation of the chunk
		randomInt = (int)Random.Range(0, chunks.Length);												//Picks a random chunk from the list
		if (chunkList[1].tag == "EmptyChunk" && chunkList[2].tag == "EmptyChunk") {						//Only 2 EmptyChunks can spawn in a row
			randomInt = (int)Random.Range(0, chunks.Length / 2);										//Half of the list are empty chunks
		}
		Destroy(chunkList[0]);																			//Destroys the last chunk
		chunkList.Remove(chunkList[0]);																	//Removes the destroyed chunk from the list
		chunkSpot += new Vector3(0, nextChunkPos, 0);													//Next chunk spot = last spot + chunk size
		GameObject chunkIns = (GameObject)Instantiate(chunks[randomInt], chunkSpot, chunkRot[rotInt]);	//Instantiates the next chunk
		chunkIns.transform.parent = chunkParent.transform;												//Sets the chunk as a child of Chunks for organization
		chunkList.Add(chunkIns);                                                                        //Adds the new chunk to the list (as index[2])
		alertManager.GetComponent<AlertManagerScript>().SetArrow();										//Spawns the arrows
	}
}
