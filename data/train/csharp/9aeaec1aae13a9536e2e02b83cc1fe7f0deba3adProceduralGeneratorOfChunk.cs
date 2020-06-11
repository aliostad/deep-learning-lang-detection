using UnityEngine;
using System.Collections.Generic;
using Magicolo;

public class ProceduralGeneratorOfChunk : MonoBehaviour
{

	public Transform playersTransform;
	
	public string levelName;
	public int currentChunkId = 0;
	public Chunk currentChunk;

	public int chunckInAdvanceOfPlayer = 4;
	public int chunckBackOfPlayer = 4;
	
	public ChunkBag chunkBag;
	public List<ChunkFlow> chunkFlowsToAdd = new List<ChunkFlow>();
	public List<ChunkFlow> chunkFlowsToRemove = new List<ChunkFlow>();
	public List<ChunkFlow> chunkFlows = new List<ChunkFlow>();
	
	public List<Chunk> chunksToAdd = new List<Chunk>();
	public List<Chunk> chunksToRemove = new List<Chunk>();
	public List<Chunk> chunks = new List<Chunk>();
	
	void Awake()
	{
		StartGeneration(GameData.seed, GameData.chunkId);
	}
	
	public void StartGeneration(int seed, int startingChunkId)
	{
		currentChunkId = startingChunkId;
		
		chunkBag = new ChunkBag(levelName);
		
		ChunkFlow chunkFlow = new ChunkFlow(this, null, chunkBag, seed, currentChunkId, Vector3.zero, 0);
		chunkFlows.Add(chunkFlow);
		Chunk newChunk = chunkFlow.loadFirstChunk();
		Vector2 start = newChunk.checkPointLocation;
		playersTransform.position = new Vector3(start.x - 2, start.y - 1, 0);
		References.Runner.rigidbody2D.velocity = Vector2.zero;
		
		chunkFlow.lastChunk.playerPassedThrought = true;
	}

	public void setCurrentChunk(Chunk chunk)
	{
		if (chunk.chunkId > this.currentChunkId) {
			currentChunk = chunk;
			currentChunkId = chunk.chunkId;
		}
		
	}

	void Start()
	{
		
	}
	
	void Update()
	{
		foreach (var chunk in chunkFlows) {
			chunk.update();
		}
		
		foreach (var chunkFlowToRemove in chunkFlowsToRemove) {
			chunkFlows.Remove(chunkFlowToRemove);
		}
		chunkFlowsToRemove.Clear();
		
		foreach (var chunkFlowToAdd in chunkFlowsToAdd) {
			chunkFlows.Add(chunkFlowToAdd);
		}
		chunkFlowsToAdd.Clear();
		
		
		
		
		foreach (var chunk in chunks) {
			if (chunk.chunkId + chunckBackOfPlayer < currentChunkId) {
				chunksToRemove.Add(chunk);
			}
		}
		
		foreach (var chunkToRemove in chunksToRemove) {
			if (chunkToRemove != null & chunkToRemove.gameObject != null) {
				/*if(chunkToRemove.chunkFlowPresent){
					Debug.Log("Remove old of" + chunkToRemove.name);
					removeUnpassedChunksFlow(chunkToRemove);
					
				}*/
				Object.Destroy(chunkToRemove.gameObject);
			}
			
			chunks.Remove(chunkToRemove);
		}
		chunksToRemove.Clear();
		
		foreach (var chunkToAdd in chunksToAdd) {
			chunks.Add(chunkToAdd);
		}
		chunksToAdd.Clear();
	}

	void removeUnpassedChunksFlow(Chunk chunkToRemove)
	{
		if (!chunkToRemove.playerPassedThrought) {
			if (chunkToRemove.nextChunk != null) {
				Debug.Log("YA UN NEXT");
				if (chunkToRemove.chunkFlowPresent) {
					Debug.Log("Remove flow of" + chunkToRemove.name);
					chunkFlowsToRemove.Add(chunkToRemove.flow);
				}
				removeUnpassedChunksFlow(chunkToRemove.nextChunk);
			}
		}
	}
	public int getChunkIdToGenerate()
	{
		return this.chunckInAdvanceOfPlayer + currentChunkId;
	}
}
