using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunks : MonoBehaviour {

    /// <summary>
    /// Active chunks
    /// </summary>
    private static List<Chunk> chunkList;

    /// <summary>
    /// Chunks are chunkSize * chunkSize
    /// </summary>
    public static int chunkSize = 23;

    /// <summary>
    /// Chunk prefab
    /// </summary>
    private static Chunk chunkPrefab;

    /// <summary>
    /// Initialization
    /// </summary>
	private void Start () {
        chunkPrefab = Resources.Load("chunk", typeof(Chunk)) as Chunk;
        chunkList = new List<Chunk>();
        loadStartingChunks();
    } 

    /// <summary>
    /// Load all 9 starting chunks
    /// </summary>
    private static void loadStartingChunks()
    {
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(0, 0, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(-chunkSize, -chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(-chunkSize, 0, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(-chunkSize, chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(0, -chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkSize, -chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkSize, 0, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(0, chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
        chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkSize, chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
    }

    /// <summary>
    /// Load and unload chunks based on the player position
    /// </summary>
    public static void updateChunks()
    {
        Vector2 currentPosition = GameObject.FindGameObjectWithTag("Player").transform.position;
        Chunk[,] chunkMatrix = new Chunk[3, 3];
        List<Chunk> chunksToDelete = new List<Chunk>();


        // fill the chunkMatrix and the chunkToDelete list according to the position of the player
        foreach (Chunk chunk in chunkList)
        {
            if (isInChunk(currentPosition, chunk))
            {
                chunkMatrix[1, 1] = chunk;
            }
            else if (isLeftUpChunk(currentPosition, chunk))
            {
                chunkMatrix[0, 0] = chunk;
            }
            else if (isLeftChunk(currentPosition, chunk))
            {
                chunkMatrix[1, 0] = chunk;
            }
            else if (isLeftDownChunk(currentPosition, chunk))
            {
                chunkMatrix[2, 0] = chunk;
            }
            else if (isUpChunk(currentPosition, chunk))
            {
                chunkMatrix[0, 1] = chunk;
            }
            else if (isDownChunk(currentPosition, chunk))
            {
                chunkMatrix[2, 1] = chunk;
            }
            else if (isRightUpChunk(currentPosition, chunk))
            {
                chunkMatrix[0, 2] = chunk;
            }
            else if (isRightChunk(currentPosition, chunk))
            {
                chunkMatrix[1, 2] = chunk;
            }
            else if (isRightDownChunk(currentPosition, chunk))
            {
                chunkMatrix[2, 2] = chunk;
            }
            else
            {
                chunksToDelete.Add(chunk);
            }
        }

        // Delete the chunks to delete
        foreach (Chunk chunk in chunksToDelete)
        {
            chunkList.Remove(chunk);
            Destroy(chunk);
        }

        // Instanciate the new chunks that are not in the chunkMatrix and add them to the chunkList
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                if (chunkMatrix[i, j] == null)
                {
                    if (j == 0)
                    {
                        if (i == 0)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x - chunkSize, chunkMatrix[1, 1].y + chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                        else if (i == 1)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x - chunkSize, chunkMatrix[1, 1].y, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                        else if (i == 2)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x - chunkSize, chunkMatrix[1, 1].y - chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                    }
                    else if (j == 1)
                    {
                        if (i == 0)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x, chunkMatrix[1, 1].y + chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                        else if (i == 2)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x, chunkMatrix[1, 1].y - chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                    }
                    else if (j == 2)
                    {
                        if (i == 0)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x + chunkSize, chunkMatrix[1, 1].y + chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                        else if (i == 1)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x + chunkSize, chunkMatrix[1, 1].y, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                        else if (i == 2)
                        {
                            chunkList.Add(GameObject.Instantiate(chunkPrefab, new Vector3(chunkMatrix[1, 1].x + chunkSize, chunkMatrix[1, 1].y - chunkSize, -10), new Quaternion(0, 0, 0, 0)) as Chunk);
                        }
                    }
                }
            }
        }
    }

    /*
    ** The methods bellow are for checking the chunks position
    ** from the player
    */
    private static bool isLeftUpChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x + chunkSize
               && position.x < chunk.x + 2 * chunkSize
               && position.y < chunk.y
               && position.y >= chunk.y - chunkSize;
    }

    private static bool isRightUpChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x - chunkSize
               && position.x < chunk.x
               && position.y < chunk.y
               && position.y >= chunk.y - chunkSize;
    }

    private static bool isRightDownChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x - chunkSize
               && position.x < chunk.x
               && position.y >= chunk.y + chunkSize
               && position.y < chunk.y + 2 * chunkSize;
    }

    private static bool isLeftDownChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x + chunkSize
               && position.x < chunk.x + 2 * chunkSize
               && position.y >= chunk.y + chunkSize
               && position.y < chunk.y + 2 * chunkSize;
    }

    private static bool isRightChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x - chunkSize
               && position.x < chunk.x
               && position.y >= chunk.y
               && position.y < chunk.y + chunkSize;
    }

    private static bool isLeftChunk(Vector2 position, Chunk chunk)
    {
        return position.x > chunk.x + chunkSize
               && position.x < chunk.x + 2 * chunkSize
               && position.y >= chunk.y
               && position.y < chunk.y + chunkSize;
    }

    private static bool isDownChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x
               && position.x < chunk.x + chunkSize
               && position.y >= chunk.y + chunkSize
               && position.y < chunk.y + 2 * chunkSize;
    }

    private static bool isUpChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x
               && position.x < chunk.x + chunkSize
               && position.y < chunk.y
               && position.y > chunk.y - chunkSize;
    }

    private static bool isInChunk(Vector2 position, Chunk chunk)
    {
        return position.x >= chunk.x
               && position.x < chunk.x + chunkSize
               && position.y >= chunk.y
               && position.y < chunk.y + chunkSize;
    }
}
