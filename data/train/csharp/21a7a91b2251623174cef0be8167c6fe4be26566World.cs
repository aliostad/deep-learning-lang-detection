using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
	public GameObject chunkPrefab;

	public string worldName = "world";
	public string seed = "hello world";

	public PhotonView photonView;

	void Start() {
		photonView = PhotonView.Get(gameObject);
		
		if(photonView.instantiationData != null) {
			object[] data = photonView.instantiationData;

			worldName = (string)data[0];
			gameObject.name = (string)data[0];
			seed = (string)data[1];
		} 
	}

	public Chunk LoadChunk(int x, int y, int z) {
		WorldPos worldPos = new WorldPos(x, y, z);

		Chunk newChunk = new Chunk();
		
		newChunk.pos = worldPos;
		newChunk.world = this;
		
		chunks.Add(worldPos, newChunk);
		
		//generate the chunk
		TerrainGen terrainGen = new TerrainGen();
		newChunk = terrainGen.ChunkGen(newChunk);
		newChunk.InitBlocks();
		
		//load changed blocks
		Serialization.LoadChunk(newChunk);

		return newChunk;
	}

	public void CreateChunk(Chunk chunk) {
		GameObject newChunkObj = Instantiate(chunkPrefab, new Vector3(chunk.pos.x, chunk.pos.y, chunk.pos.z), Quaternion.identity) as GameObject;
		ChunkContainer newChunkContainer = newChunkObj.GetComponent<ChunkContainer>();
		newChunkContainer.chunk = chunk;
		newChunkContainer.chunk.container = newChunkContainer;
	}

	public void DestroyChunk(int x, int y, int z) {
		Chunk chunk = null;
		if(chunks.TryGetValue(new WorldPos(x, y, z), out chunk)) {
			Serialization.SaveChunk(chunk);
			Object.Destroy(chunk.container.gameObject);
			chunks.Remove(new WorldPos(x, y, z));
		}
	}

	public Chunk GetChunk(int x, int y, int z) {
		WorldPos pos = new WorldPos();
		float multiple = Chunk.chunkSize;
		pos.x = Mathf.FloorToInt(x/multiple) * Chunk.chunkSize;
		pos.y = Mathf.FloorToInt(y/multiple) * Chunk.chunkSize;
		pos.z = Mathf.FloorToInt(z/multiple) * Chunk.chunkSize;

		Chunk containerChunk = null;
		chunks.TryGetValue(pos, out containerChunk);
		return containerChunk;
	}
	
	public Block GetBlock(int x, int y, int z) {
		Chunk containerChunk = GetChunk(x, y, z);

		if(containerChunk == null)
			return new BlockAir();

		Block block  = containerChunk.GetBlock(x - containerChunk.pos.x, y - containerChunk.pos.y, z - containerChunk.pos.z);//convert world coords to local chunk coords
		return block;
	}

	public void SetBlock(int x, int y, int z, Block block) {
		Chunk chunk = GetChunk(x, y, z);

		if(chunk != null) {
			chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
			chunk.update = true;

			//update adjacent chunks if needed
			UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
			UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
			UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
			UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
			UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
			UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
		}
	}

	void UpdateIfEqual(int v1, int v2, WorldPos pos) {
		if(v1 == v2) {
			Chunk c = GetChunk(pos.x, pos.y, pos.z);
			if(c != null)
				c.update = true;
		}
	}
}
