using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
	public GameObject chunkPrefab;
	public int newChunkX;
    public int newChunkY;
    public int newChunkZ;
  
    public bool genChunk;
	// Use this for initialization
	public string worldName = "world";  
	void Start(){	
	    for (int x = -2; x < 2; x++)
	    {
	        for (int y = -1; y < 0; y++)
	        {
	            for (int z = -1; z < 1; z++)
	            {
	                CreateChunk(x * 16, y * 16, z * 16);
	            }
	        }
	    }
	}
	
	// Update is called once per frame
	void Update () {
		if (genChunk)
        {
            genChunk = false;
            WorldPos chunkPos = new WorldPos(newChunkX, newChunkY, newChunkZ);
            Chunk chunk = null;
  
            if (chunks.TryGetValue(chunkPos, out chunk))
            {
                DestroyChunk(chunkPos.x, chunkPos.y, chunkPos.z);
            }
            else
            {
                CreateChunk(chunkPos.x, chunkPos.y, chunkPos.z);
            }
        }
	}
	public void CreateChunk(int x, int y, int z)
    {
        //the coordinates of this chunk in the world
        WorldPos worldPos = new WorldPos(x, y, z);
          //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(
                        chunkPrefab, new Vector3(worldPos.x, worldPos.y, worldPos.z),
                        Quaternion.Euler(Vector3.zero)
                    ) as GameObject;
  
        //Get the object's chunk component
        Chunk newChunk = newChunkObject.GetComponent<Chunk>();
  
        //Assign its values
        newChunk.pos = worldPos;
        newChunk.world = this;
        //Add it to the chunks dictionary with the position as the key
        chunks.Add(worldPos, newChunk);
        
  
        //Add the following:
        for (int xi = 0; xi < 16; xi++)
        {
            for (int yi = 0; yi < 16; yi++)
            {
                for (int zi = 0; zi < 16; zi++)
                {
                    if (yi <= 7)
                    {
                        SetBlock(x+xi, y+yi, z+zi, new BlockGrass());
                    }
                    else
                    {
                        SetBlock(x + xi, y + yi, z + zi, new BlockAir());
                    }
                }
            }
        }
        newChunk.SetBlocksUnmodified();
        Serialization.Load(newChunk);
    }
    public Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        float multiple = Chunk.chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple ) * Chunk.chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple ) * Chunk.chunkSize;
        pos.z = Mathf.FloorToInt(z / multiple ) * Chunk.chunkSize;
        Chunk containerChunk = null;
        chunks.TryGetValue(pos, out containerChunk);
  
        return containerChunk;
    }
    public Block GetBlock(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y, z);
        if (containerChunk != null)
        {
            Block block = containerChunk.GetBlock(
                x - containerChunk.pos.x,
                y -containerChunk.pos.y,
                z - containerChunk.pos.z);
  
            return block;
        }
        else
        {
            return new BlockAir();
        }
  
    }
    public void SetBlock(int x, int y, int z, Block block)
    {
        Chunk chunk = GetChunk(x, y, z);
 
        if (chunk != null)
        {
            chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
            chunk.update = true;
            UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
			UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
			UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
			UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
			UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
			UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
        }
    }
    public void DestroyChunk(int x, int y, int z)
    {
        Chunk chunk = null;
        if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
        {
        	Serialization.SaveChunk(chunk);    //Add this line to the function
            Object.Destroy(chunk.gameObject);
            chunks.Remove(new WorldPos(x, y, z));
        }
    }
    void UpdateIfEqual(int value1, int value2, WorldPos pos)
     {
         if (value1 == value2)
         {
             Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
             if (chunk != null)
                 chunk.update = true;
         }
     }
}
