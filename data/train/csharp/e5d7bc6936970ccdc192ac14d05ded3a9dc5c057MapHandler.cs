using UnityEngine;
using System.Collections;
using UnityEngine.Networking;

public class MapHandler : MonoBehaviour {

    private GameObject chunk;

    private GameHandler gameH;
    private PlayerHandler playerH;

    private float sizeChunk = 100f;
    private int nbSquare = 10;
    private int radiusVisibleChunk = 4;
    private Vector2 positionCenterChunk;
    private string[] listChunks;

    private float lowXLimit;
    private float highXLimit;
    private float lowZLimit;
    private float highZLimit;
    
    // Update is called once per frame
    void FixedUpdate () {
        MajChunks();
    }

    public void InitMap(GameHandler gameHandler)
    {
        chunk = Resources.Load("Prefabs/Chunk") as GameObject;

        gameH = gameHandler;
        //playerH = playerHandler;
        //playerH = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerHandler>();
        
        CreateInitialsChunks();
    }

    void CreateInitialsChunks()
    {
        Vector3 posPlayer;
        if (playerH) posPlayer = playerH.transform.position;
        else posPlayer = new Vector3(0f, 0f, 0f);
        positionCenterChunk = posPlayer;
        SetInitialCenter();

        for (int i = -radiusVisibleChunk; i <= radiusVisibleChunk; i++)
        {
            for (int j = -radiusVisibleChunk; j <= radiusVisibleChunk; j++)
            {
                CreateChunk(posPlayer.x + i * sizeChunk, posPlayer.z + j * sizeChunk);

            }
        }
    }

    void CreateChunk(float positionX, float positionZ)
    {
        GameObject instance;
        instance = Instantiate(chunk, new Vector3(0, 0, 0), Quaternion.identity) as GameObject;
        instance.transform.SetParent(this.transform);
        ChunkHandler ch = instance.GetComponent<ChunkHandler>();
        ch.InitChunk(positionX, positionZ, sizeChunk, nbSquare);
    }

    void DestroyChunk(float positionX, float positionZ)
    {
        string chunkName = "Chunk" + positionX + "_" + positionZ;
        Destroy(GameObject.Find(chunkName));
    }

    void SetInitialCenter()
    {
        Vector3 posPlayer;
        if (playerH) posPlayer = playerH.transform.position;
        else posPlayer = new Vector3(0f, 0f, 0f);
        positionCenterChunk.x = (Mathf.Round(posPlayer.x / sizeChunk) * sizeChunk);
        positionCenterChunk.y = (Mathf.Round(posPlayer.z / sizeChunk) * sizeChunk);
        lowXLimit = (Mathf.Round(posPlayer.x / sizeChunk) * sizeChunk) - sizeChunk / 2;
        highXLimit = (Mathf.Round(posPlayer.x / sizeChunk) * sizeChunk) + sizeChunk / 2;
        lowZLimit = (Mathf.Round(posPlayer.z / sizeChunk) * sizeChunk) - sizeChunk / 2;
        highZLimit = (Mathf.Round(posPlayer.z / sizeChunk) * sizeChunk) + sizeChunk / 2;
    }

    public void SetPlayer(PlayerHandler player)
    {
        playerH = player;
    }

    void MajChunks()
    {
        Vector3 posPlayer;
        if (playerH) posPlayer = playerH.transform.position;
        else posPlayer = new Vector3(0f, 0f, 0f);
        if (posPlayer.x < lowXLimit)
        {
            lowXLimit -= sizeChunk;
            highXLimit -= sizeChunk;            
            for(int i = 0; i < (radiusVisibleChunk*2+1); i++)
            {
                float newChunkX = positionCenterChunk.x - ((radiusVisibleChunk + 1) * sizeChunk);
                float newChunkZ = positionCenterChunk.y - (radiusVisibleChunk * sizeChunk) + i *sizeChunk;
                CreateChunk(newChunkX, newChunkZ);
            }
            positionCenterChunk.x -= sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x + ((radiusVisibleChunk + 1) * sizeChunk);
                float newChunkZ = positionCenterChunk.y - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                DestroyChunk(newChunkX, newChunkZ);
            }
        }
        else if (posPlayer.x > highXLimit)
        {
            lowXLimit += sizeChunk;
            highXLimit += sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x + ((radiusVisibleChunk + 1) * sizeChunk);
                float newChunkZ = positionCenterChunk.y - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                CreateChunk(newChunkX, newChunkZ);
            }
            positionCenterChunk.x += sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x - ((radiusVisibleChunk + 1) * sizeChunk);
                float newChunkZ = positionCenterChunk.y - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                DestroyChunk(newChunkX, newChunkZ);
            }
        }
        if (posPlayer.z < lowZLimit)
        {
            lowZLimit -= sizeChunk;
            highZLimit -= sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                float newChunkZ = positionCenterChunk.y - ((radiusVisibleChunk + 1) * sizeChunk);
                CreateChunk(newChunkX, newChunkZ);
            }
            positionCenterChunk.y -= sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                float newChunkZ = positionCenterChunk.y + ((radiusVisibleChunk + 1) * sizeChunk);
                DestroyChunk(newChunkX, newChunkZ);
            }
        }
        else if (posPlayer.z > highZLimit)
        {
            lowZLimit += sizeChunk;
            highZLimit += sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                float newChunkZ = positionCenterChunk.y + ((radiusVisibleChunk + 1) * sizeChunk);
                CreateChunk(newChunkX, newChunkZ);
            }
            positionCenterChunk.y += sizeChunk;
            for (int i = 0; i < (radiusVisibleChunk * 2 + 1); i++)
            {
                float newChunkX = positionCenterChunk.x - (radiusVisibleChunk * sizeChunk) + i * sizeChunk;
                float newChunkZ = positionCenterChunk.y - ((radiusVisibleChunk + 1) * sizeChunk);
                DestroyChunk(newChunkX, newChunkZ);
            }
        }
    }

}
