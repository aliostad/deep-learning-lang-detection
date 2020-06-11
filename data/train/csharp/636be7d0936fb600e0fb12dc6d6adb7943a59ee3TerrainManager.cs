using UnityEngine;
using System.Collections;

public class TerrainManager : MonoBehaviour {

	public int Size = 10;
    public int NoiseSamples = 1;
    public float Height = 20;
    public Material Material;
	public GameObject Player;
	private Hashtable chunks = new Hashtable();
	// Use this for initialization
	void Start () {
    }
	
	// Update is called once per frame
	void Update () {
        int offset = Size / 2;
        Vector3 chunkCenterPosition = new Vector3((int)(Player.transform.position.x / Size), 0, (int)Player.transform.position.z / Size);

        for (int x = -1; x <= 1; x++)
        {
            for (int z = -1; z <= 1; z++)
            {
                Vector3 chunkPosition = new Vector3(chunkCenterPosition.x + x, chunkCenterPosition.y, chunkCenterPosition.z + z);

                if (!chunks.Contains(chunkPosition))
                {
                    Debug.Log("Created chunk at " + chunkPosition.ToString());
                    Chunk chunk = new Chunk((int)chunkPosition.x, (int)chunkPosition.z, Size, NoiseSamples, Height, Material);
                    chunk.Plane.transform.position = chunkPosition * Size;
                    chunk.Plane.transform.position = new Vector3(chunk.Plane.transform.position.x - offset, chunk.Plane.transform.position.y, chunk.Plane.transform.position.z);
                    chunks.Add(chunkPosition, chunk);
                }
            }
        }
	}
}
