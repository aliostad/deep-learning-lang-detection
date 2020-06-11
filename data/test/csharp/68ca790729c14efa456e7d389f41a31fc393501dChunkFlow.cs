using System.Collections;
using System.Runtime.CompilerServices;
using UnityEngine;
using System.Collections.Generic;
using Magicolo;

[System.Serializable]
public class ChunkFlow
{

	
	public Vector3 direction;
	public float rotation;
	
	[Disable] public Vector3 lastRoomEndPosition;
	[Disable] public int lastRoomRightExitY;
	[Disable] public int nextChunkId = 1;
	[Disable] public Chunk lastChunk;
	
	[Disable]public ChunkBag chunkBag;
	private ProceduralGeneratorOfChunk proceduralGeneratorOfChunk;
	private Transform generationParentTransform;
	
	public int seed;
	public System.Random random;
	public float nextCornerChance = 0.5F;
	public float baseCornerChance = 0.5f;
	public float baseCornerChanceIncremental = 0.1f;

	public ChunkFlow(ProceduralGeneratorOfChunk proceduralGeneratorOfChunk, Chunk lastChunk, ChunkBag chunkBag, int seed, int startingChunkId, Vector3 startingPosition, float angle)
	{
		lastRoomEndPosition = startingPosition;
		this.proceduralGeneratorOfChunk = proceduralGeneratorOfChunk;
		generationParentTransform = proceduralGeneratorOfChunk.transform;
		this.chunkBag = chunkBag;
		this.lastChunk = lastChunk;
		this.seed = seed;
		this.random = new System.Random(seed);
		this.nextChunkId = startingChunkId;
		rotation = angle;
		
		makeStartChunk();
	}
	
	public void update()
	{
		if (playerIsInThisFlow()) {
			if (proceduralGeneratorOfChunk.getChunkIdToGenerate() > nextChunkId) {
				loadNextChunk();
			}
		} else {
			proceduralGeneratorOfChunk.chunkFlowsToRemove.Add(this);
		}
		
	}

	bool playerIsInThisFlow()
	{
		Chunk previousChunk = lastChunk;
		while (previousChunk != null) {
			if (previousChunk.playerPassedThrought) {
				return true;
			} else {
				previousChunk = previousChunk.lastChunk;
			}
		}
		
		return false;
	}
	
	public Chunk loadFirstChunk()
	{
		GameObject nextChunkPrefab = chunkBag.getRandomChunk(random);
		Chunk newChunk = createAndPlaceNewChunk(nextChunkPrefab, nextChunkId, 1);
		newChunk.orientation = this.rotation;
		nextChunkId++;
		return newChunk;
	}
	
	public void loadNextChunk()
	{
		float nextrandom = (float)random.NextDouble();
		if (isPlaying()) {
			makeStraightChunk();
		} else {
			if (nextrandom <= nextCornerChance) {
				nextCornerChance = baseCornerChance;
				makeCornerChunk();
			} else {
				nextCornerChance += baseCornerChanceIncremental;
				makeStraightChunk();
			}
		}
		
	}
	
	bool isPlaying()
	{
		return AudioMaster.currentAudioClip != null && AudioMaster.currentAudioClip.State == PureDataStates.Playing;
	}

	Chunk makeCornerChunk()
	{
		GameObject nextChunkPrefab = chunkBag.getRandomChunkFrom(random, chunkBag.cornerChunkPrefab);
		if (nextChunkPrefab == null) {
			return null;
		}
		
		Chunk newChunk = createAndPlaceNewChunk(nextChunkPrefab, nextChunkId, 0.1F);
		newChunk.orientation = this.rotation;
		nextChunkId++;
		
		if (newChunk.upExitX != -1) {
			Vector3 movement = new Vector3(-newChunk.width + newChunk.upExitX, newChunk.height, 0);
			float newAngle = (rotation + 90) % 360;
			
			makeFlow(newChunk, movement, newAngle, nextChunkId);
		}
		
		if (newChunk.downExitX != -1) {
			Vector3 movement = new Vector3(-newChunk.width + newChunk.downExitX, 0, 0);
			float newAngle = (rotation - 90) % 360;
			
			makeFlow(newChunk, movement, newAngle, nextChunkId);
		}
		
		if (newChunk.rightExitY == -1) {
			proceduralGeneratorOfChunk.chunkFlowsToRemove.Add(this);
		}
		return newChunk;
	}

	void makeFlow(Chunk chunk, Vector3 movement, float newAngle, int chunkId)
	{
		Vector3 startingPosition = moveRelative(lastRoomEndPosition, movement, rotation);
		ChunkFlow newFlow = new ChunkFlow(proceduralGeneratorOfChunk, lastChunk, chunkBag, random.Next(), chunkId, startingPosition, newAngle);
		chunk.flow = newFlow;
		chunk.chunkFlowPresent = true;
		proceduralGeneratorOfChunk.chunkFlowsToAdd.Add(newFlow);
	}
	
	
	Vector3 moveRelative(Vector3 target, Vector3 translation, float rotationToDo)
	{
		Vector3 movement = translation.Rotate(rotationToDo, Vector3.back);
		return target + movement;
	}

	Chunk makeStartChunk(){
		GameObject nextChunkPrefab = chunkBag.getRandomStartChunk(random);
		Chunk newChunk = createAndPlaceNewChunk(nextChunkPrefab, nextChunkId, 1);
		newChunk.randomToGenerate = this.seed;
		nextChunkId++;
		newChunk.orientation = this.rotation;
		return newChunk;
	}
	
	Chunk makeStraightChunk()
	{
		GameObject nextChunkPrefab = chunkBag.getRandomChunk(random);
		Chunk newChunk = createAndPlaceNewChunk(nextChunkPrefab, nextChunkId, 0.1F);
		newChunk.orientation = this.rotation;
		nextChunkId++;
		return newChunk;
	}

	Chunk createAndPlaceNewChunk(GameObject prefab, int chunkId, float loadSpeed)
	{
		Chunk prefabChunk = prefab.GetComponent<Chunk>();
		int yDifference = this.lastRoomRightExitY - prefabChunk.entreanceY;
		Vector3 movement = new Vector3(0, yDifference, 0);
		movement = movement.Rotate(rotation, Vector3.back);
		lastRoomEndPosition += movement;
		
		
		Chunk newChunk = createChunk(prefab, chunkId, loadSpeed);
		if (lastChunk != null) {
			lastChunk.nextChunk = newChunk;
			newChunk.lastChunk = lastChunk;
		}
		lastChunk = newChunk;
		
		proceduralGeneratorOfChunk.chunksToAdd.Add(newChunk);
		newChunk.chunkId = chunkId;
		newChunk.proceduralGenerator = proceduralGeneratorOfChunk;
		
		Vector3 movementX = new Vector3(prefabChunk.width, 0, 0);
		movementX = movementX.Rotate(rotation, Vector3.back);
		lastRoomEndPosition += movementX;
		lastRoomRightExitY = prefabChunk.rightExitY;
		return newChunk;
	}
	
	Chunk createChunk(GameObject prefab, int chunkId, float loadSpeed)
	{
		GameObject newChunkGO = new GameObject("Chunk" + chunkId);
		newChunkGO.transform.parent = generationParentTransform;
		newChunkGO.transform.position = lastRoomEndPosition;
		newChunkGO.transform.Rotate(0, 0, rotation);
		newChunkGO.layer = LayerMask.NameToLayer("Chunk");
		
		Chunk newChunk = newChunkGO.AddComponent<Chunk>();
		prefab.GetComponent<Chunk>().copyTo(newChunk);
		
		BoxCollider2D prefabCollider = prefab.GetComponent<BoxCollider2D>();
		BoxCollider2D newChunkCollider = newChunkGO.AddComponent<BoxCollider2D>();
		newChunkCollider.isTrigger = prefabCollider.isTrigger;
		newChunkCollider.center = prefabCollider.center;
		newChunkCollider.size = prefabCollider.size;
		
		proceduralGeneratorOfChunk.StartCoroutine(createTiles(prefab, newChunkGO, loadSpeed));
		
		return newChunk;
	}
	
	IEnumerator createTiles(GameObject prefab, GameObject parent, float loadSpeed)
	{
		GameObject prefabTiles = prefab.GetChild(0);
		int counter = 0;
		int tilesPerFrame = (int)(prefabTiles.GetChildCount() * loadSpeed);
		
		GameObject newTilesGO = new GameObject("Tiles");
		newTilesGO.transform.parent = parent.transform;
		newTilesGO.transform.Reset();
		
		foreach (GameObject child in prefabTiles.GetChildren()) {
			GameObject newChild = Object.Instantiate(child, child.transform.position, Quaternion.Euler(0, 0, rotation)) as GameObject;
			newChild.transform.parent = newTilesGO.transform;
			newChild.transform.localPosition = child.transform.localPosition;
			
			counter += 1;
			
			if (counter >= tilesPerFrame) {
				counter = 0;
				yield return new WaitForSeconds(0);
			}
		}
	}
}
