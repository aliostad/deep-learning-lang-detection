using UnityEngine;
using System;
using System.Collections; 

[System.Serializable]
public class SerializedChunk {
	
	public int chunkSize; 
	public float chunkPositionX;
	public float chunkPositionY;
	public SerializedTile[,] tiles;

	public SerializedChunk (Chunk chunk) { 
		chunkSize = chunk.chunkSize;
		chunkPositionX = chunk.chunkPosition.x;
		chunkPositionY = chunk.chunkPosition.y; 
		tiles = new SerializedTile[chunkSize, chunkSize];

		for(int x = 0; x < chunk.chunkSize; x++ ) {
			
			for(int y = 0; y < chunk.chunkSize; y++ ) {
				if(chunk.tiles[x,y] != null) {
					tiles[x,y] = new SerializedTile(); 
					tiles[x,y].sand = chunk.tiles[x,y].sand;
					tiles[x,y].silt = chunk.tiles[x,y].silt;
					tiles[x,y].clay = chunk.tiles[x,y].clay;
				}
			}
		}

	}

	public SerializedChunk(int chunkSize, int chunkPositionX, int chunkPositionY, SerializedTile[,] tiles) {
		this.chunkSize = chunkSize;
		this.chunkPositionX = chunkPositionX;
		this.chunkPositionY = chunkPositionY;
		this.tiles = tiles;
	}

	public void WriteToChunk(Chunk chunk) {
		 
		chunk.chunkSize = chunkSize;
		chunk.chunkPosition = new Vector2 (chunkPositionX, chunkPositionY);
		 
		for(int x = 0; x < chunk.chunkSize; x++ ) {
			
			for(int y = 0; y < chunk.chunkSize; y++ ) {

				chunk.tiles = new Tile[chunkSize,chunkSize];

				//look at setting these values with reflection
				if(tiles[x,y] != null) {
					chunk.CreateTile(x,y);
					chunk.tiles[x,y].sand = tiles[x,y].sand;
					chunk.tiles[x,y].silt = tiles[x,y].silt;
					chunk.tiles[x,y].clay = tiles[x,y].clay;
				}
			}
		}
	}
	   
}
