using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkSpawner : MonoBehaviour {

    public int totalNumOfChunks;

    public GameObject wobble;
    float levelLength = 0;
    int numberOfChunks = 0;

    List<GameObject> chunks = new List<GameObject>();

	// Use this for initialization
	void Start () {
        /*
        GameObject chunk = (GameObject)Instantiate(Resources.Load("Chunk1"));
        levelLength = chunk.GetComponent<Chunk>().chunkLength;
        chunk.transform.position = new Vector3(0, 0, 0);
        numberOfChunks++;
        chunks.Add(chunk);
         * */

        SpawnChunk("1");
	}
	
	// Update is called once per frame
	void Update () {
        /*
        if (wobble.transform.position.x > levelLength - 25)
        {
            int rand = Random.Range(1, totalNumOfChunks+1);

            GameObject chunk = (GameObject)Instantiate(Resources.Load("Chunk" + rand.ToString()));
            chunk.transform.position = new Vector3(levelLength, 0, 0);
            levelLength += chunk.GetComponent<Chunk>().chunkLength;
            numberOfChunks++;
            chunks.Add(chunk);
        }
         * 
         * * */
        if (chunks.Count > 5)
        {
            GameObject.Destroy(chunks[0]);
            chunks.RemoveAt(0);
        } 
         
	}

    public Chunk SpawnChunk()
    {
        int rand = Random.Range(1, totalNumOfChunks + 1);

        GameObject chunk = (GameObject)Instantiate(Resources.Load("Chunk" + rand.ToString()));
        chunk.transform.position = new Vector3(levelLength, 0, 0);
        levelLength += chunk.GetComponent<Chunk>().chunkLength;
        numberOfChunks++;
        chunks.Add(chunk);

        return chunk.GetComponent<Chunk>();
    }

    public void SpawnChunk(string chunkNum)
    {
//        int rand = Random.Range(1, totalNumOfChunks + 1);

        GameObject chunk = (GameObject)Instantiate(Resources.Load("Chunk" + chunkNum));
        chunk.transform.position = new Vector3(levelLength, 0, 0);
        levelLength += chunk.GetComponent<Chunk>().chunkLength;
        numberOfChunks++;
        chunks.Add(chunk);
    }
        
}
