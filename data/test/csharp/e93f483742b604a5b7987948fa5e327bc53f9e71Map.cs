/*using UnityEngine;
using System;

public class Map : MonoBehaviour{
	
	public Vector2 tileScale;
	
	public MapChunk[] chunkMap;
	
	public MapChunk chunkPrefab;
	
	public int width;
	
	public int height;
	
	public int chunkWidth;
	public int chunkHeight;
	
	public GameObject prefab;
	
	void Awake(){
	
		chunkMap = new MapChunk[width*height];
		
		AddChunkAt(3,3);
		
		InitializeChunkAt(3,3);
		
		InitializeChunkAt(2,2);
	}

	public void InitializeChunkAt(int x, int y){
	
		if(HasChunkAt(x,y)){
			
			GameObject[] newObjects = new GameObject[chunkWidth*chunkHeight];
		
			for(int i = 0; i < chunkWidth*chunkHeight; i++){
				newObjects[i] = GameObject.Instantiate(prefab) as GameObject;
			}
			
			GetChunkAt(x,y).Editor_InitializeChunk(newObjects);
			
			for(int x1 = x-1; x1 <= x+1; x1++){
				for(int y1 = y-1; y1 <= y+1; y1++){
				
					if(!HasChunkAt(x1,y1)){
						
						AddChunkAt(x1,y1);
						
					}	
					else{
						Debug.Log("Chunk already exists at: " + x1 + "," + y1);
					}
					
				}	
			}
		}
	}
	
	public void AddChunkAt(int x, int y){
	
		Debug.Log("adding chunk at : " + x + " , " + y);
		
		int index = y * width + x;
		
		if(index < 0 || index >= chunkMap.Length || x < 0 || y < 0 || x >= width || y >= height){
			
			Debug.Log("Out of range, aborting.");
			
			return;
		}
		
		chunkMap[index] = GameObject.Instantiate(chunkPrefab) as MapChunk;
		
		chunkMap[index].name = x+"_"+y+"_chunk";
		
		chunkMap[index].Editor_Activate(x,y,chunkWidth,chunkHeight,this);
		
	}
	
	public bool HasChunkAt(int x, int y){
		
		int index = y * width + x;
		
		if(index < 0 || index >= chunkMap.Length){
			return false;
		}
		
		return (chunkMap[index] != null);
	}
	
	public MapChunk GetChunkAt(int x, int y){
		int index = y * width + x;
		return chunkMap[index];
	}
}*/