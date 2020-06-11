using UnityEngine;
using UnityEngine.Networking;
using System.Collections;

public class TileMassNetworker : NetworkBehaviour {

	TileMass tMass;
	
	void Start(){
		
		tMass = GetComponent<TileMass>();
	}
	
	[ClientRpc]
	public void RpcSetTileAt(Vector2 position, int id){
		
		TileChunk cPrefab = tMass.tileChunkPrefab.GetComponent<TileChunk>();
		Debug.Log("Yup");
		int x = (int) position.x;
		int y = (int) position.y;
		
		int chunkX = (int) (x / cPrefab.chunkSizeX);
		int chunkY = (int) (y / cPrefab.chunkSizeY);
		
		int tileX = (int) (x - chunkX * cPrefab.chunkSizeX);
		int tileY = (int) (y - chunkY * cPrefab.chunkSizeY);
		
		tMass.tileChunks[chunkX, chunkY].GetComponent<TileChunk>().tiles[tileX, tileY].tileID = id;
		
		tMass.BuildChunk(new Vector2(chunkX, chunkY), false);
		
		if(tileX == 0)
			tMass.BuildChunk(new Vector2(chunkX - 1, chunkY), false);
		
		if(tileX == cPrefab.chunkSizeX - 1)
			tMass.BuildChunk(new Vector2(chunkX + 1, chunkY), false);
		
		if(tileY == 0)
			tMass.BuildChunk(new Vector2(chunkX, chunkY - 1), false);
		
		if(tileY == cPrefab.chunkSizeY -1)
			tMass.BuildChunk(new Vector2(chunkX, chunkY + 1), false);
		
	}
	
	[ClientRpc]
	public void RpcSetTileAtNoBuild(Vector2 position, int id){
		
		TileChunk cPrefab = tMass.tileChunkPrefab.GetComponent<TileChunk>();
		Debug.Log("Yup");
		int x = (int) position.x;
		int y = (int) position.y;
		
		int chunkX = (int) (x / cPrefab.chunkSizeX);
		int chunkY = (int) (y / cPrefab.chunkSizeY);
		
		int tileX = (int) (x - chunkX * cPrefab.chunkSizeX);
		int tileY = (int) (y - chunkY * cPrefab.chunkSizeY);
		
		tMass.tileChunks[chunkX, chunkY].GetComponent<TileChunk>().tiles[tileX, tileY].tileID = id;
	}
}
