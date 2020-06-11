using UnityEngine;
using System.Collections;

public class TerrainGenerator : MonoBehaviour {

	//Three chunks at a time
	public Chunk previousChunk;	
	public Chunk currentChunk;
	public Chunk nextChunk;

	public GameObject character;
	
	void Start(){

		RepositionChunks ();


		currentChunk.CreateGaps ();
		//nextChunk.CreateGaps ();

		//create random gaps and randomize height
		//currentRandomHeight = nextChunk.RandomizeSection (currentRandomHeight);

	}

	private void RepositionChunks(){
		//get the width of ground prefab.
		float widthPrefabs = previousChunk.WidthGroundPrefab;
		
		
		//reposition of chunk
		previousChunk.RepositionChunk (new Vector3 (-widthPrefabs * Chunk.CHUNK_SIZE, 0, 0));
		currentChunk.RepositionChunk (Vector3.zero);
		nextChunk.RepositionChunk (new Vector3 (widthPrefabs * Chunk.CHUNK_SIZE, 0, 0));

	}

	void Update(){
		if (PlayerReachedNextChunk ()) {
			ReassginChunks();

			//create gaps in the next chunk
			//nextChunk.CreateGaps();


			//create random gaps and randomize height
			//currentRandomHeight = nextChunk.RandomizeSection (currentRandomHeight);
		}
	}

	private bool PlayerReachedNextChunk(){
		bool playerReachedNextChunk = false;

		float distance = character.transform.position.x - nextChunk.transform.position.x;

		if(distance > 0){
			playerReachedNextChunk = true;
		}

		return playerReachedNextChunk;
	}



	private void ReassginChunks(){
		//keep reference of previous chunk
		Chunk refToPrev = previousChunk;

		//Reassigning the chunks so we can resue them

		previousChunk = currentChunk;
		currentChunk = nextChunk;
		nextChunk = refToPrev;

		float xPos = nextChunk.transform.position.x + 3 * nextChunk.WidthGroundPrefab * Chunk.CHUNK_SIZE;

		nextChunk.RepositionChunk (new Vector3 (xPos, 0, 0));

	}

	public void Restart(){
		RepositionChunks ();
		RepositionSection ();
	}


	//Reset each child section
	private void RepositionSection(){
		previousChunk.ResetChildPosition ();
		currentChunk.ResetChildPosition ();
		nextChunk.ResetChildPosition ();

		//create random gaps and randomize height
		//currentRandomHeight = nextChunk.RandomizeSection (currentRandomHeight);

	}
}
