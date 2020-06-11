using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Stairway : MonoBehaviour {

	public Transform player;
	public float distanceToPlayer = 5.0f;
	public GameObject firstChunk;
	public int totalSteps;
	public int chunkSizeInStepts = 10;

	public Vector3 chunkPosIncremental;

	public GameObject[] chunks;

	private List<GameObject> chunkInstances;



	private GameObject currentChunk;
	// Use this for initialization
	void Start () {
		currentChunk = firstChunk;

		totalSteps = chunkSizeInStepts;

		chunkInstances = new List<GameObject> ();
		chunkInstances.Add (currentChunk);
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public GameObject addRandomChunk(){
		int max = chunks.Length;

		int value = Random.Range (0, max);

		return instantiateChunk (value);

	}
	private GameObject instantiateChunk(int index){

		//Debug.Log (index);

		GameObject chunk = (GameObject)Instantiate (chunks [index], Vector3.zero, Quaternion.identity);

		chunk.transform.parent = this.transform;


		chunk.transform.localPosition = currentChunk.transform.position + chunkPosIncremental;

		currentChunk.GetComponent<Chunk> ().nextChunk = chunk.GetComponent<Chunk> ();

		currentChunk = chunk;

		totalSteps += chunkSizeInStepts;

		chunkInstances.Add (chunk);

		return chunk;
	}

	public void StartFall(){
		firstChunk.GetComponent<Chunk> ().Fall (player, distanceToPlayer);
		AudioSource audioSource = GetComponent<AudioSource> ();
		audioSource.Play ();
	}

}
