using UnityEngine;
using System.Collections;
using UnityEngine.Networking;


public class World : NetworkBehaviour {

    public static World currentWorld;
    public bool server;

    [SyncVar]
    public int chunkWidth = 20, chunkHeight = 20, seed = 0;
	public float viewRange = 100;
	
	
	public Chunk chunkFab;
	
	// Use this for initialization
	void Start () {
        currentWorld = this;
        if (server)
        {
            if (seed == 0)
                seed = Random.Range(0, int.MaxValue);
        }
	}
	
	// Update is called once per frame
	void Update () {

        if (server)
        {
            for (float x = -2 * chunkWidth; x < 2 * chunkWidth; x += chunkWidth)
            {
                for (float y = transform.position.y - viewRange; y < transform.position.y + viewRange; y += chunkHeight)
                {
                    for (float z = -2 * chunkWidth; z < 2 * chunkWidth; z += chunkWidth)
                    {


                        Vector3 pos = new Vector3(x, y, z);
                        pos.x = Mathf.Floor(pos.x / (float)chunkWidth) * chunkWidth;
                        pos.y = Mathf.Floor(pos.y / (float)chunkHeight) * chunkHeight;
                        pos.z = Mathf.Floor(pos.z / (float)chunkWidth) * chunkWidth;


                        Chunk chunk = Chunk.FindChunk(pos);
                        if (chunk != null) continue;

                        chunk = (Chunk)Instantiate(chunkFab, pos, Quaternion.identity);

                        NetworkServer.Spawn(chunk.gameObject);
                        //				for (int i = 0; i < chunkWidth * chunkWidth; i++) {
                        //					chunk.setBlock (Mathf.RoundToInt (Random.RandomRange (0, chunkWidth)), Mathf.RoundToInt (Random.RandomRange (0, chunkHeight)), Mathf.RoundToInt (Random.RandomRange (0, chunkWidth)), 4);
                        //				}

                    }
                }
            }
        }
	
	}


}


