using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;


public class World : MonoBehaviour{
	public GameObject chunkGo;

	Dictionary<Vector2, Chunk> chunkMap;

	void Awake(){
		chunkMap = new Dictionary<Vector2,Chunk> ();
	}

	void Start(){


	}
	void Update(){
		FindChunkToLoad ();
	}

	void FindChunkToLoad(){
		int xPos = (int)transform.position.x;
		int yPos = (int)transform.position.y;

		for (int i = xPos - (2*Chunk.size); i < xPos + (2*Chunk.size); i+= Chunk.size) {
			for (int j = yPos - (2*Chunk.size); j < yPos + (2*Chunk.size); j+= Chunk.size) {
				MakeChunkAt (i, j); 
			}
		}
	}

	void MakeChunkAt(int x, int y){
		x = Mathf.FloorToInt( x / (float) Chunk.size ) * Chunk.size;
		y = Mathf.FloorToInt( y / (float) Chunk.size ) * Chunk.size;

		if(chunkMap.ContainsKey(new Vector2(x,y)) == false){
			GameObject go = Instantiate (chunkGo, new Vector3 (x, y, 0f), Quaternion.identity);
			chunkMap.Add(new Vector2(x,y),go.GetComponent<Chunk>());
		}
	}

	void DeleteChunkAt(int x, int y){
		
	}


}
