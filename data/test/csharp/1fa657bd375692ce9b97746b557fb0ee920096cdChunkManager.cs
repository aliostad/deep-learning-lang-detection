using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Prime31.MessageKit;

public class ChunkManager : MonoBehaviour {

	public static ChunkManager i;
	public Player player;
	public int randomSeed;
	public Chunk chunkPrefab;
	public float side;
	public float maxDepth;
	public float spawnRadius;
	public Chunk currentChunk;
	public Chunk originChunk;
	public float triggerCooldown = 0.5f;
	public List<ChunkInfo> allChunkInfo;

	void Awake () {
		i = this;
		randomSeed = Random.Range(0, 100);
		allChunkInfo = new List<ChunkInfo>();
	}

	// Use this for initialization
	void Start () {
		// listeners
		MessageKit<ChunkInfo>.addObserver(MsgType.PlayerChangedChunk, LoadAllNeighbors);
		// setup
		originChunk.info = new ChunkInfo(0, 0);
		currentChunk = originChunk;
		currentChunk.info.obj = currentChunk;
		originChunk.GetComponentInChildren<ElevationDeform>().Deform();
		originChunk.GetComponentInChildren<PropPlacer>().Place();
		allChunkInfo.Add(currentChunk.info);
		StartCoroutine(LoadAround(currentChunk.info));
	}

	public bool CreateChunkAt(int x, int z){
		if(GetChunk(x, z) == null) {
			ChunkInfo info = new ChunkInfo(x, z);
			Chunk newChunk = Instantiate(chunkPrefab, new Vector3(info.worldX, 0, info.worldZ), 
			                             Quaternion.identity) as Chunk;
			newChunk.info = info;
			newChunk.info.obj = newChunk;
			allChunkInfo.Remove(newChunk.info);
			allChunkInfo.Add(newChunk.info);
			newChunk.transform.parent = transform;
			newChunk.GetComponentInChildren<ElevationDeform>().Deform();
			newChunk.GetComponentInChildren<PropPlacer>().Place();
			MessageKit.post(MsgType.ChunkCreated);
			newChunk.transform.position += new Vector3(0, -maxDepth, 0);
			return true;
		}
		return false;
	}

	IEnumerator LoadAround(ChunkInfo info) {
		foreach (ChunkInfo chunk in ChunkInfo.ChunksInArea(info.gridX, info.gridZ, 1)){
			CreateChunkAt(chunk.gridX, chunk.gridZ);
			yield return null;
		}
	}

	void LoadAllNeighbors (ChunkInfo info) {
		StartCoroutine(LoadAround(info));
	}
	
	public Chunk GetChunk (int x, int z) {
		ChunkInfo info = new ChunkInfo(x, z);
		if(allChunkInfo.Find(c => c == info) == null) return null;
		else return allChunkInfo.Find(c => c == info).obj;
	}

	public ChunkInfo GetChunkInfo (int x, int z) {
		ChunkInfo info = new ChunkInfo(x,z);
		return allChunkInfo.Find(c => c == info);
	}

}
