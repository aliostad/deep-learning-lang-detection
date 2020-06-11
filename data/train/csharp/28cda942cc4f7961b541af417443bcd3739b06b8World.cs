using UnityEngine;
using System.Collections;

public class World : MonoBehaviour
{
	public WorldData data;
    public float blockSize = 1.0f;

	void Start ()
	{
		if (data != null)
		{
            CreateChunk(0, 0);
		}
	}

    public Chunk CreateChunk(int x, int y)
    {
        GameObject newGameObject = new GameObject(string.Format("Chunk:{0};{1}", x, y));
        Chunk newChunk = newGameObject.AddComponent<Chunk>();

        newChunk.data = new ChunkData(data, x, y);

        ChunkData[] chunkNeighbors;
        bool[] foundNeighbors = data.TryGetChunkNeighbors(x, y, out chunkNeighbors);
        for (int i = 0; i < foundNeighbors.Length; i++)
        {
            if (foundNeighbors[i] == true)
            {
                newChunk.data.neighbors[i] = chunkNeighbors[i];
                chunkNeighbors[i].neighbors[i] = newChunk.data;
            }
        }
        
        newChunk.Initialize(this);

        return newChunk;
    }
}
