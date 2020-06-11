using UnityEngine;
using System.Collections;

public class TerrainGenerator : MonoBehaviour 
{
	//three chunks at a time 
	public Chunk previousChunk;
	public Chunk currentChunk;
	public Chunk nextChunk;
	
	void Start()
	{
		//get width of ground prefab
		float widthPrefab = previousChunk.WidthGroundPrefab;
		
		//reposition chunks
		previousChunk.RepositionChunk(new Vector3(-widthPrefab*Chunk.CHUNK_SIZE, 0, 0));
		currentChunk.RepositionChunk(Vector3.zero);
		nextChunk.RepositionChunk(new Vector3(widthPrefab*Chunk.CHUNK_SIZE, 0, 0));
	}
}
