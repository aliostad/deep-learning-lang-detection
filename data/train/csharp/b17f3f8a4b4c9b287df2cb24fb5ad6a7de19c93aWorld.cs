using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SimplexNoise;

public class World : MonoBehaviour {

	public Chunk chunk;

    public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();

	//Chunk temp;

	//List<WorldPos> pending = new List<WorldPos>();

	//int sizeX = 6;
	//int sizeY = 3;
	//int sizeZ = 6;

    public static int chunkMargin = 2;
    public static int chunkHeight = 128;
    public static int chunkSize = 30;

	void Start()
	{
        /*
		for(int x = 0; x < sizeX; ++x)
		{
			for(int z = 0; z < sizeZ; ++z)
			{
				for(int y = 0; y < sizeY; ++y)
				{
					pending.Add (new WorldPos(x, y, z));
				}
			}
		}

		CreateChunk();
        */
	}

	void Update()
	{
        /*
		if(pending.Count > 0)
		{
			if(temp.Complete())
			{
				CreateChunk();
			}
		}
        */
	}

    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        float multiple = chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * chunkSize;
        pos.z = Mathf.FloorToInt(z / multiple) * chunkSize;

        Chunk containerChunk = null;

        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }

	public void CreateChunk(int x, int y, int z)
	{
        WorldPos worldPos = new WorldPos(x, y, z);
		//if(pending.Count > 0)
		//{
            Chunk c = Instantiate(chunk, worldPos.ToVector() - new Vector3(chunkSize / 2f, chunkSize / 2f, chunkSize / 2f), new Quaternion()) as Chunk;
			c.transform.parent = transform;
            chunks.Add(worldPos, c);
		//}
	}

    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {
            Object.Destroy(chunk.gameObject);
            Debug.Log("Deleting Chunk " + "(" + x + "," + y + "," + z + ")");
            chunks.Remove(new WorldPos(x, y, z));
        }
    }
}
