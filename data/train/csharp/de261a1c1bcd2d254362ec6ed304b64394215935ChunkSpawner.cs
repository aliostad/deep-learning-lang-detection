using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkSpawner : MonoBehaviour {

    public GameObject player;
    public GameObject chunk;

    public int orgTimer;
    public float orgSpace;

    int timer;
    float nextChunkX;

	// Use this for initialization
	void Start () {
        timer = orgTimer;
        nextChunkX = orgSpace;
    }
	
    

    void generateNextChunk(float chunkX, GameObject chunk)
    {
        GameObject chunkClone = Instantiate(chunk, new Vector2(chunkX, chunk.transform.position.y), chunk.transform.rotation);

        Destroy(chunkClone, orgTimer * Time.deltaTime * 2);
    }

	// Update is called once per frame
	void FixedUpdate () {
        if (timer <= 0)
        {
            generateNextChunk(nextChunkX, chunk);

            nextChunkX += orgSpace;
            timer = orgTimer;
        }
        else
        {
            timer -= 1;
        }
	}
}
