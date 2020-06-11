using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkHandler : InjectedMonoBehaviour
{
    [SerializeField]
    private int chunkSizeX = 16;
    [SerializeField]
    private int chunkSizeY = 16;
    [SerializeField]
    private int chunkSizeZ = 16;

    [Inject]
    private World world;

	void Start () {
        world.OnWorldCreated.AddListener(onWorldCreated);
	}

    private void onWorldCreated()
    {
        foreach (Transform child in transform)
        {
            GameObject.Destroy(child.gameObject);
        }

        int chunksX = Mathf.CeilToInt(1.0f * world.WorldSizeX / chunkSizeX);
        int chunksY = Mathf.CeilToInt(1.0f * world.WorldSizeY / chunkSizeY);
        int chunksZ = Mathf.CeilToInt(1.0f * world.WorldSizeZ / chunkSizeZ);

        for (int chunkX = 0; chunkX < chunksX; chunkX++)
        {
            for (int chunkY = 0; chunkY < chunksY; chunkY++)
            {
                for (int chunkZ = 0; chunkZ < chunksZ; chunkZ++)
                {
                    GameObject chunkContainer = new GameObject();
                    chunkContainer.transform.SetParent(transform);
                    Chunk chunk = chunkContainer.AddComponent<Chunk>();
                    chunk.Initialize(world, chunkX, chunkY, chunkZ, chunkSizeX, chunkSizeY, chunkSizeZ);
                }
            }
        }
    }
}
