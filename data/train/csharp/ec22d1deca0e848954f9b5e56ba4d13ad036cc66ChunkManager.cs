using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/*
 * Chunk Manager creates and destroys chunks and the player 
 * moves around
 */

public class ChunkManager{
	
	private const int CHUNK_RADIUS = 5;
	private Dictionary<int, Chunk> chunks = new Dictionary<int, Chunk>();
	
	private Chunk AddChunk(int x, int z){
		Debug.Log ("ADDING CHUNK!");
		int idx = (x << 16) ^ z;
		// check if chunk already exists
		// if so , skip
		if(!chunks.ContainsKey(idx)){
			Chunk chunk = new Chunk(x, z);	
			chunks[idx] = chunk;
			return chunk;
		}
		return null;
	}
	
	private void RemoveChunk(int x, int z){
		int idx = (x << 16) ^ z;
		if (chunks.ContainsKey(idx)){
			Debug.Log ("DESTROYING CHUNK!");
			Chunk chunk = chunks[idx];
			chunks.Remove(idx);
			GameObject.Destroy(chunk.go);
		}
	}

	public ChunkManager () {		
		BuildAndDestroyChunks();
	}	

	public void UpdateResolutions(){
		GameObject player = GameObject.Find("Player");
		foreach(Chunk chunk in chunks.Values){
			float distance = (chunk.GetPosition() + new Vector3(Chunk.SIZE_RX/2, 0, Chunk.SIZE_RX/2) - player.transform.position).magnitude;
			float x = 1/(Mathf.Pow(distance, 1.1f));
			if((chunk.GetSize() < 64) && (x  > 0.00002*chunk.GetSize())){
				while((chunk.GetSize() < 64) && (x  > 0.00002*chunk.GetSize())){
					chunk.DoubleResolution();	
				}
			} 
		}
	}
	public void BuildAndDestroyChunks(){
		GameObject player = GameObject.Find("Player");
		// make a chunk near the player
		
		//Chunk c1 = new Chunk(0,0);
		
		int player_world_x = (int)Mathf.Round(player.transform.position.x / Chunk.SIZE_RX + 0.5f);
		int player_world_z = (int)Mathf.Round ((player.transform.position.z - (player_world_x-0.5f)*0.577350269189626f*Chunk.SIZE_RX)/Chunk.SIZE_RZ + 0.5f);
		
		AddChunk(player_world_x,player_world_z);
		
		/* create chunk around
		 */
		for(int x = 1; x < CHUNK_RADIUS; x++){
			for	(int z = 1; z < CHUNK_RADIUS; z++){
				if(x + z < CHUNK_RADIUS){
					AddChunk(player_world_x+x,player_world_z+z);
					AddChunk(player_world_x-x,player_world_z-z);
					AddChunk(player_world_x-x,player_world_z+z);
					AddChunk(player_world_x+x,player_world_z-z);
				}
			}
			AddChunk(player_world_x,player_world_z+x);
			AddChunk(player_world_x,player_world_z-x);
			AddChunk(player_world_x-x,player_world_z);
			AddChunk(player_world_x+x,player_world_z);
		}
		
		// destroy
		List<int[]> to_remove = new List<int[]>();
		foreach(Chunk chunk in chunks.Values){
			if(Mathf.Abs(player_world_x-chunk.world_x)+Mathf.Abs(player_world_z-chunk.world_z) > CHUNK_RADIUS){
				to_remove.Add(new int[]{chunk.world_x, chunk.world_z});
			}
		}
		foreach(int[] coord in to_remove){
			RemoveChunk(coord[0],coord[1]);		
		}
	}
}