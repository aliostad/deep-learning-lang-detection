using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour 
{
    /* Fields */
    [System.Serializable] public struct WorldGenData
    {
        [Header("World Settings")]
        [Range(16,124)]
        public int chunkSize;
        [Range(32, 64)]
        public int spriteResolution;
    }
    [SerializeField] WorldGenData _worldGenData;
    public WorldGenData worldGenData
    {
        get { return _worldGenData; }
    }

    ChunkGenerator _chunkGenerator;

    /* Base */
    void Start()
    {
        _chunkGenerator = new ChunkGenerator(this);

        int chunkSize = worldGenData.chunkSize;
        for (int i = 0; i < 9; i++)
        {
            Chunk newChunk = _chunkGenerator.GenerateChunk();

            switch (i)
            {
                case 0:
                    newChunk.gameObject.transform.position = new Vector3(-chunkSize, chunkSize,0);
                    break;
                case 1:
                    newChunk.gameObject.transform.position = new Vector3(0,          chunkSize, 0);
                    break;
                case 2:
                    newChunk.gameObject.transform.position = new Vector3(chunkSize,  chunkSize, 0);
                    break;
                case 3:
                    newChunk.gameObject.transform.position = new Vector3(-chunkSize, 0, 0);
                    break;
                case 4:
                    newChunk.gameObject.transform.position = new Vector3(0,          0, 0);
                    break;
                case 5:
                    newChunk.gameObject.transform.position = new Vector3(chunkSize,  0, 0);
                    break;
                case 6:
                    newChunk.gameObject.transform.position = new Vector3(-chunkSize, -chunkSize, 0);
                    break;
                case 7:
                    newChunk.gameObject.transform.position = new Vector3(0,          -chunkSize, 0);
                    break;
                case 8:
                    newChunk.gameObject.transform.position = new Vector3(chunkSize,  -chunkSize, 0);
                    break;
            }
        }
    }

    void Update()
    {
        
    }

    /* External */

    /* Internal */
}

/* TODO LIST */
/*
 *  - Make chunks load in sprites rather than placing random colors
 *  - Make a basic marker that surrounds the tile which the player hovers with its cursor 
 */