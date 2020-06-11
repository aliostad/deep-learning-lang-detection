using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Noise;

public class World : MonoBehaviour {

	public NoiseGen noiseGen = new NoiseGen();
	public GameObject player;
	public Vector3 playerChunk, prevPlayerChunk = new Vector3(9, 9, 9);
	List<Chunk> chunks = new List<Chunk>();
	public GameObject chunk;
	private int chunkSize = 1;

	void Start () {
		
	}

	void Update () {
		handleChunks();
	}

	void handleChunks(){
		playerChunk = new Vector3((int) player.transform.position.x / chunkSize, (int) player.transform.position.y / chunkSize, (int) player.transform.position.z / chunkSize);
		if(playerChunk != prevPlayerChunk){
			for(int x = (int) playerChunk.x - 4; x <= playerChunk.x + 4; x ++){
				for(int z = (int) playerChunk.z - 4; z <= (int) playerChunk.z + 4; z ++){
					for(int y = 0; y < 160; y ++){
						Chunk searchResult = searchChunks(new Vector3(x, y, z));
						if(searchResult == null){
							Chunk newChunk = genChunk(new Vector3(x, y, z));
							chunks.Add(newChunk);
							newChunk.chunkPos = new Vector3(x, y, z);
							newChunk.worldGO=gameObject;
							newChunk.chunkSize = chunkSize;
							newChunk.initChunk();
						}
						else searchResult.gameObject.SetActive(true);
					}
				}
			}
			prevPlayerChunk = playerChunk;
			for(int i = 0; i < chunks.Count; i ++){
				if(!(chunks[i].chunkPos.x > playerChunk.x - 2 && chunks[i].chunkPos.x < playerChunk.x + 2 && chunks[i].chunkPos.z > playerChunk.z - 2 && chunks[i].chunkPos.z < playerChunk.z + 2)){
					chunks[i].gameObject.SetActive(false);
				}
			}
		}
	}

	Chunk genChunk(Vector3 chunkPos){
		GameObject newChunk = Instantiate(chunk,new Vector3(chunkPos.x * chunkSize, chunkPos.y * chunkSize, chunkPos.z * chunkSize), new Quaternion(0,0,0,0)) as GameObject;
		return newChunk.GetComponent("Chunk") as Chunk;
	}

	public Chunk searchChunks(Vector3 chunkPos){
		for(int i = 0; i < chunks.Count; i ++){
			if(chunks[i].chunkPos.x == chunkPos.x && chunks[i].chunkPos.y == chunkPos.y && chunks[i].chunkPos.z == chunkPos.z){
				return chunks[i];
			}
		}
		return null;
	}

	int PerlinNoise(int x,int y, int z, float scale, float height, float power){
		float rValue;
		rValue= noiseGen.GetNoise(((double)x) / scale * 10, ((double)y)/ scale, ((double)z) / scale / 5);
		rValue*=height * 5;
		
		if(power!=0){
			rValue=Mathf.Pow( rValue, power);
		}
		
		return (int) rValue;
	}

}
