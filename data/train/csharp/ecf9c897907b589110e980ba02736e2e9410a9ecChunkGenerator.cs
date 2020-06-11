using UnityEngine;
using System.Collections;

public class ChunkGenerator : MonoBehaviour {
	public int seed = 0;
	public int chunkSize = 10;
	public int chunkLoadRadius = 5;
	public GameObject[] chunks;
	public GameObject follow;
	Vector2 lastchunk,currentchunk;
	// Use this for initialization
	void Start () {
		Vector2 chunk_position = new Vector2(Mathf.FloorToInt(follow.transform.position.x/chunkSize),Mathf.FloorToInt(follow.transform.position.y/chunkSize));
		GameObject g;
		for(int x = -chunkLoadRadius; x<chunkLoadRadius; x++)
		{ 
			for(int y = -chunkLoadRadius; y<chunkLoadRadius; y++)
			{
				
				Random.seed = (int)((chunk_position.x+x)+(chunk_position.y+y))+seed;
				g = (GameObject)GameObject.Instantiate(chunks[Random.Range(0,chunks.GetLength(0))],new Vector3((chunk_position.x+x)*chunkSize,(chunk_position.y+y)*chunkSize,0),Quaternion.identity);
				g.GetComponent<ChunkBehavior>().radius = chunkSize * chunkLoadRadius;
				g.GetComponent<ChunkBehavior>().follow = follow;
			
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		Vector2 chunk_position = new Vector2(Mathf.FloorToInt(follow.transform.position.x/chunkSize),Mathf.FloorToInt(follow.transform.position.y/chunkSize));
		currentchunk = chunk_position;
		if(currentchunk != lastchunk)
		{
			if(currentchunk.x > lastchunk.x)
			{
				GameObject g;
				for(int y = -chunkLoadRadius; y<chunkLoadRadius; y++)
				{
					Random.seed = (int)((chunk_position.x+1)+(chunk_position.y+y))+seed;
					g = (GameObject)GameObject.Instantiate(chunks[Random.Range(0,chunks.GetLength(0))],new Vector3((chunk_position.x+(chunkLoadRadius-1))*chunkSize,(chunk_position.y+y)*chunkSize,0),Quaternion.identity);
					g.GetComponent<ChunkBehavior>().radius = chunkSize * chunkLoadRadius;
					g.GetComponent<ChunkBehavior>().follow = follow;
				}
			}
			if(currentchunk.x < lastchunk.x)
			{
				GameObject g;
				for(int y = -chunkLoadRadius; y<chunkLoadRadius; y++)
				{
					Random.seed = (int)((chunk_position.x+1)+(chunk_position.y+y))+seed;
					g = (GameObject)GameObject.Instantiate(chunks[Random.Range(0,chunks.GetLength(0))],new Vector3((chunk_position.x-(chunkLoadRadius-1))*chunkSize,(chunk_position.y+y)*chunkSize,0),Quaternion.identity);
					g.GetComponent<ChunkBehavior>().radius = chunkSize * chunkLoadRadius;
					g.GetComponent<ChunkBehavior>().follow = follow;
				}
			}
			if(currentchunk.y > lastchunk.y)
			{
				GameObject g;
				for(int y = -chunkLoadRadius; y<chunkLoadRadius; y++)
				{
					Random.seed = (int)((chunk_position.x+1)+(chunk_position.y+y))+seed;
					g = (GameObject)GameObject.Instantiate(chunks[Random.Range(0,chunks.GetLength(0))],new Vector3((chunk_position.x+y)*chunkSize,(chunk_position.y+(chunkLoadRadius-1))*chunkSize,0),Quaternion.identity);
					g.GetComponent<ChunkBehavior>().radius = chunkSize * chunkLoadRadius;
					g.GetComponent<ChunkBehavior>().follow = follow;
				}
			}
			if(currentchunk.y < lastchunk.y)
			{
				GameObject g;
				for(int y = -chunkLoadRadius; y<chunkLoadRadius; y++)
				{
					Random.seed = (int)((chunk_position.x-1)+(chunk_position.y+y))+seed;
					g = (GameObject)GameObject.Instantiate(chunks[Random.Range(0,chunks.GetLength(0))],new Vector3((chunk_position.x-y)*chunkSize,(chunk_position.y-(chunkLoadRadius-1))*chunkSize,0),Quaternion.identity);
					g.GetComponent<ChunkBehavior>().radius = chunkSize * chunkLoadRadius;
					g.GetComponent<ChunkBehavior>().follow = follow;
				}
			}
			
		}
		lastchunk = currentchunk;
		

	}
}
