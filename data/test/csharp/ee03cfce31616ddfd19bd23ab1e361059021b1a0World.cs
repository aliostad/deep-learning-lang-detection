using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour {

    public Dictionary<WorldPos, AVVoxel.Chunk> chunks = new Dictionary<WorldPos, AVVoxel.Chunk>();
    public GameObject chunkPrefab;
    public GameObject cloudPrefab;
    public string worldName = "world2";

    public Structure[] Trees;
    public Structure[] PineTrees;
    public Structure[] Grass;
    public Structure[] Seaweed;

    public int newChunkX;
    public int newChunkY;
    public int newChunkZ;
    public bool genChunk;
    //public bool CanChunk = true;

	//// Use this for initialization
	//void Start () {
	//	for(int x = -2; x < 20; x++)
 //       {
 //           for(int y = 0; y < 1; y++)
 //           {
 //               for(int z = -1; z < 20; z++)
 //               {
 //                   CreateChunk(x * AVVoxel.Chunk.chunkSizeX, y * AVVoxel.Chunk.chunkSizeY, z * AVVoxel.Chunk.chunkSizeZ);
 //               }
 //           }
 //       }
	//}
	
	//// Update is called once per frame
	//void Update () {
	//	if(genChunk)
 //       {
 //           genChunk = false;
 //           WorldPos chunkPos = new WorldPos(newChunkX, newChunkY, newChunkZ);
 //           AVVoxel.Chunk chunk = null;

 //           if(chunks.TryGetValue(chunkPos, out chunk))
 //           {
 //               DestroyChunk(chunkPos.x, chunkPos.y, chunkPos.z);
 //           }
 //           else
 //           {
 //               CreateChunk(chunkPos.x, chunkPos.y, chunkPos.z);
 //           }
 //       }
	//}

    public void CreateChunk(int x, int y, int z)
    {
        WorldPos worldPos = new WorldPos(x, y, z);

        GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(worldPos.x, worldPos.y, worldPos.z), Quaternion.Euler(Vector3.zero)) as GameObject;

        AVVoxel.Chunk newChunk = newChunkObject.GetComponent<AVVoxel.Chunk>();

        newChunk.worldPos = worldPos;
        newChunk.world = this;

        chunks.Add(worldPos, newChunk);

        TerrainGen terrainGen = new TerrainGen();  
        terrainGen.Trees = Trees;
        terrainGen.PineTrees = PineTrees;
        terrainGen.Grass = Grass;
        terrainGen.Seaweed = Seaweed;
         newChunk = terrainGen.ChunkGen(newChunk);

        //CanChunk = false;
       // StartCoroutine(terrainGen.ChunkGenRoutine(newChunk,this));
        newChunk.SetBlocksUnmodified();
        Serialization.Load(newChunk); 

       // CreateCloud(x, y, z);
    }

    public void CreateCloud(int x, int y, int z)
    {
        WorldPos worldPos = new WorldPos(x, y + 40, z);

        GameObject newCloudObject = Instantiate(cloudPrefab, new Vector3(worldPos.x, worldPos.y, worldPos.z), Quaternion.Euler(Vector3.zero)) as GameObject;

        AVVoxel.Cloud newCloud = newCloudObject.GetComponent<AVVoxel.Cloud>();
          
        newCloud.worldPos = worldPos;
        newCloud.world = this;

        //chunks.Add(worldPos, newCloud); 

        CloudGen cloudGen = new CloudGen();
       
        newCloud = cloudGen.ChunkGen(newCloud);
 
    }

    public AVVoxel.Chunk GetChunk(int x, int y, int z)
    {
        WorldPos pos = new WorldPos();
        float multipleX = AVVoxel.Chunk.chunkSizeX;
        float multipleY = AVVoxel.Chunk.chunkSizeY;
        float multipleZ = AVVoxel.Chunk.chunkSizeZ;

        pos.x = Mathf.FloorToInt(x / multipleX) * AVVoxel.Chunk.chunkSizeX;
        pos.y = Mathf.FloorToInt(y / multipleY) * AVVoxel.Chunk.chunkSizeY;
        pos.z = Mathf.FloorToInt(z / multipleZ) * AVVoxel.Chunk.chunkSizeZ;

        AVVoxel.Chunk containerChunk = null;
        chunks.TryGetValue(pos, out containerChunk); 
        return containerChunk;

    }

    public void DestroyChunk(int x, int y, int z)
    {
        AVVoxel.Chunk chunk = null;
        WorldPos pos = new WorldPos(x, y, z);
        if(chunks.TryGetValue(pos, out chunk))
        {
            Serialization.SaveChunk(chunk);

           foreach(MeshFilter filter in chunk.gameObject.GetComponentsInChildren<MeshFilter>())
            {
                Mesh mesh = filter.sharedMesh;
                DestroyImmediate(mesh, true);

            }
            foreach (MeshCollider collider in chunk.gameObject.GetComponentsInChildren<MeshCollider>())
            {
                Mesh mesh = collider.sharedMesh;
                DestroyImmediate(mesh, true);
            }

            Object.DestroyImmediate(chunk.gameObject);
            chunks.Remove(pos);
        }
    }

    public void SaveAll()
    {

        foreach (KeyValuePair<WorldPos, AVVoxel.Chunk> chunk in chunks)
        {
            // do something with entry.Value or entry.Key
        
        
            Serialization.SaveChunk(chunk.Value);
           
        }

    }

    public Block GetBlock(int x, int y, int z)
    {
        AVVoxel.Chunk containerChunk = GetChunk(x, y, z);
        if(containerChunk != null)
        {
            Block block = containerChunk.GetBlock(x - containerChunk.worldPos.x, y - containerChunk.worldPos.y, z - containerChunk.worldPos.z);
            return block; 
        }
        else
        {
            return new BlockAir();
        }
    }

    public void SetBlock(int x, int y, int z, Block block, bool onlyIfEmpty = false)
    {
        AVVoxel.Chunk chunk = GetChunk(x, y, z);

        //if theres a chunk to put a block in
        if(chunk != null)
        {
            chunk.SetBlock(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, block, onlyIfEmpty);
            //make sure chunk updates mesh
            chunk.update = true;

            //update blocks in other chunks as well (stop there being invisible faces)
            UpdateIfEqual(x - chunk.worldPos.x, 0, new WorldPos(x - 1, y, z));
            UpdateIfEqual(x - chunk.worldPos.x, AVVoxel.Chunk.chunkSizeX - 1, new WorldPos(x + 1, y, z));
            UpdateIfEqual(y - chunk.worldPos.y, 0, new WorldPos(x, y - 1, z));
            UpdateIfEqual(y - chunk.worldPos.y, AVVoxel.Chunk.chunkSizeY - 1, new WorldPos(x, y + 1, z));
            UpdateIfEqual(z - chunk.worldPos.z, 0, new WorldPos(x, y, z - 1));
            UpdateIfEqual(z - chunk.worldPos.z, AVVoxel.Chunk.chunkSizeZ - 1, new WorldPos(x, y, z + 1));
        }
    }

    public void SetBlockFromUser(int x, int y, int z, Block block)
    {
        AVVoxel.Chunk chunk = GetChunk(x, y, z);

        //if theres a chunk to put a block in
        if (chunk != null)
        {
            chunk.SetBlockFromUser(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, block);
            //make sure chunk updates mesh
            chunk.updateFromUser = true;

            //update blocks in other chunks as well (stop there being invisible faces)
            UpdateIfEqualFromUser(x - chunk.worldPos.x, 0, new WorldPos(x - 1, y, z));
            UpdateIfEqualFromUser(x - chunk.worldPos.x, AVVoxel.Chunk.chunkSizeX - 1, new WorldPos(x + 1, y, z));
            UpdateIfEqualFromUser(y - chunk.worldPos.y, 0, new WorldPos(x, y - 1, z));
            UpdateIfEqualFromUser(y - chunk.worldPos.y, AVVoxel.Chunk.chunkSizeY - 1, new WorldPos(x, y + 1, z));
            UpdateIfEqualFromUser(z - chunk.worldPos.z, 0, new WorldPos(x, y, z - 1));
            UpdateIfEqualFromUser(z - chunk.worldPos.z, AVVoxel.Chunk.chunkSizeZ - 1, new WorldPos(x, y, z + 1));
        }
    }

    void UpdateIfEqual(int value1, int value2, WorldPos pos)
    {
        if(value1 == value2)
        {
            AVVoxel.Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if(chunk!= null)
            {
                chunk.update = true;
            }
        }
    }

    void UpdateIfEqualFromUser(int value1, int value2, WorldPos pos)
    {
        if (value1 == value2)
        {
            AVVoxel.Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
            {
                chunk.updateFromUser = true;
            }
        }
    }

    
}
