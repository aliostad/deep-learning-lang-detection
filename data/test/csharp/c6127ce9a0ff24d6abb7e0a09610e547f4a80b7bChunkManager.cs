using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class ChunkManager : MonoBehaviour {

	public bool newChunk = false;
	public GameObject chunkTemplate;
	public GameObject currentChunk;
	public GameObject left;
	public GameObject right;
	int chunkSize;
	public Slider smoothingSlider; 


	public GameObject[] chunkMap = new GameObject[20];

	// Use this for initialization
	void Start () {
		currentChunk = (GameObject)Instantiate(chunkTemplate, transform);
		currentChunk.GetComponent<ChunkBehaviour> ().NextChunk (this.gameObject, (int)(smoothingSlider.value*10)+1);
		chunkMap [chunkMap.Length/2] = currentChunk;
		currentChunk.name =  (chunkMap.Length / 2).ToString();
	}

	public void SetChunk(GameObject chunk){
		int index = System.Array.IndexOf (chunkMap, chunk);

		currentChunk = chunk;
		left = chunkMap [index - 1];
		right = chunkMap [index + 1];

		if (left == null){
			left = makeChunk(-1);
			left.name = (index - 1).ToString();
			chunkMap [index - 1] = left;
		}
		if (right == null){
			right = makeChunk(1);
			right.name = (index + 1).ToString();
			chunkMap [index + 1] = right;
		}

	}

	// Update is called once per frame
	void FixedUpdate () {
		if (newChunk == true) {
			newChunk = false;
			GameObject lastTile = currentChunk.GetComponent<ChunkBehaviour> ().lastTile;
			Vector3 pos = new Vector3(currentChunk.transform.position.x + currentChunk.GetComponent<ChunkBehaviour>().chunksize, currentChunk.transform.position.y, currentChunk.transform.position.z);
			currentChunk = (GameObject)Instantiate (chunkTemplate, pos, transform.rotation);
			currentChunk.transform.parent = transform;
			currentChunk.GetComponent<ChunkBehaviour> ().NextChunk (lastTile, (int)(smoothingSlider.value*10)+1);
		}
	}

	GameObject makeChunk(int dir){
		GameObject lastTile = currentChunk.GetComponent<ChunkBehaviour> ().lastTile;
		GameObject thisChunk;
		Vector3 pos = new Vector3(currentChunk.transform.position.x + dir*currentChunk.GetComponent<ChunkBehaviour>().chunksize, currentChunk.transform.position.y, currentChunk.transform.position.z);
		thisChunk = (GameObject)Instantiate (chunkTemplate, pos, transform.rotation);
		thisChunk.transform.parent = transform;
		thisChunk.GetComponent<ChunkBehaviour> ().NextChunk (lastTile, (int)(smoothingSlider.value*10)+1);
		return thisChunk;
	}


}
