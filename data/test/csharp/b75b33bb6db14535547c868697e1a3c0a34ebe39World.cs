using UnityEngine;
using System.Collections;

public class World : MonoBehaviour {

	public static World currentWorld;

	public int chunkWidth = 60, chunkHeight = 60, seed =0;
	public float viewRange = 30;

	public Chunk chunkFab;

	// Use this for initialization
	void Awake () {
		currentWorld = this;
		if (seed == 0) 
			seed = Random.Range(0, int.MaxValue);
	}
	
	// Update is called once per frame
	void Update () {
		for (float x= transform.position.x - viewRange; x < transform.position.x; x+= chunkWidth)
		{
			for (float z= transform.position.x - viewRange; z < transform.position.y; z+= chunkWidth)
			{
				Vector3 pos = new Vector3(x,0,z);
				pos.x = Mathf.Floor (pos.x / (float) chunkWidth) * chunkWidth;
				pos.z = Mathf.Floor (pos.z / (float) chunkWidth) * chunkWidth;

				Debug.Log(pos);
				Chunk chunk = Chunk.FindChunk(pos);

				if (chunk == null)
					Debug.Log (pos+ ":NO Chunk");
				else
				{
					Debug.Log(pos + ":chunk at " + chunk.transform.position);
					continue;
				}

				chunk = (Chunk)Instantiate(chunkFab, pos, Quaternion.identity);
			} 
		} 
	}
}
