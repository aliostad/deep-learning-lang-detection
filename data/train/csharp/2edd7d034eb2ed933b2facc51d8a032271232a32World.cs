using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {
    
    public int chunkSize = 10;
    public int chunkHeight = 10;
    public int LOD;

    public float noiseScaleFactor = 20;
    public float voxelSize = 1;
    Chunk[,] worldChunks;
    public Material meshMaterial;
    public Vector3 worldStartPosition;
    float timer;

    public int RenderDistance;

    public List<Chunk> chunks;
    public Chunk[,] chunksArray;

    public GameObject Player;
    public int seed;

    public Vector2 Tree_Pos;
    public bool CreateTreeBool;

    List<Chunk> chunksToUpdate;

    public GameObject treePrefab;

    public int SetLOD;
    public bool SetLODBool;
    int low_lod = 4;
    int med_lod = 2;
    int high_lod = 1;

    public float mediumLodDistance;
    public float farLodDistance;


    GameObject Terrain;
	// Use this for initialization
	void Start () {
        chunksToUpdate = new List<Chunk>();
        worldStartPosition = new Vector3(0, 0, 0);
        chunksArray = new Chunk[5000, 5000];
        chunks = new List<Chunk>();

        Terrain = GameObject.FindGameObjectWithTag("Terrain");
    }

    Chunk CreateChunk(int x, int z)
    {
        return new Chunk(new Vector3(x * chunkSize * voxelSize, 0, z * chunkSize * voxelSize), chunkSize, chunkHeight, noiseScaleFactor, voxelSize, meshMaterial, seed, low_lod);
    }

    public void AddChunkToUpdate(Chunk chunk)
    {
        if (!chunksToUpdate.Contains(chunk))
        {
            chunksToUpdate.Add(chunk);
        }
    }
    public void AddDensity(int x, int y, int z, float val, bool doVoxelSize)
    {
        if (doVoxelSize)
        {
            x /= (int)voxelSize;
            y /= (int)voxelSize;
            z /= (int)voxelSize;
        }
        int xChunk = x / chunkSize;
        int zChunk = z / chunkSize;

        // Offsets for negative chunks

        int xVert = x % chunkSize;
        int zVert = z % chunkSize;

        if (xVert < 0)
        {
            xVert = chunkSize + xVert;
            xChunk--;
        }
        if (zVert < 0)
        {
            zVert = chunkSize + zVert;
            zChunk--;
        }
        chunksArray[xChunk + chunkOffset, zChunk + chunkOffset].addIsoLevel(xVert, y, zVert, val);
        AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk + chunkOffset]);

        // Update neighbor chunks if we need to
        if (xVert == 0)
        {
            chunksArray[xChunk - 1 + chunkOffset, zChunk + chunkOffset].addIsoLevel(chunkSize, y, zVert, val);
            AddChunkToUpdate(chunksArray[xChunk - 1 + chunkOffset, zChunk + chunkOffset]);
        }
        if (xVert == chunkSize)
        {
            chunksArray[xChunk + 1 + chunkOffset, zChunk + chunkOffset].addIsoLevel(0, y, zVert, val);
            AddChunkToUpdate(chunksArray[xChunk + 1 + chunkOffset, zChunk + chunkOffset]);
        }
        if (zVert == 0)
        {
            chunksArray[xChunk + chunkOffset, zChunk - 1 + chunkOffset].addIsoLevel(xVert, y, chunkSize, val);
            AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk - 1 + chunkOffset]);
        }
        if (zVert == chunkSize)
        {
            chunksArray[xChunk + chunkOffset, zChunk + 1 + chunkOffset].addIsoLevel(xVert, y, 0, val);
            AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk + 1 + chunkOffset]);
        }
        if (xVert == chunkSize && zVert == chunkSize)
        {
            chunksArray[xChunk + 1 + chunkOffset, zChunk + 1 + chunkOffset].addIsoLevel(0, y, 0, val);
            AddChunkToUpdate(chunksArray[xChunk + 1 + chunkOffset, zChunk + 1 + chunkOffset]);
        }
        if (xVert == 0 && zVert == 0)
        {
            chunksArray[xChunk - 1 + chunkOffset, zChunk - 1 + chunkOffset].addIsoLevel(chunkSize, y, chunkSize, val);
            AddChunkToUpdate(chunksArray[xChunk - 1 + chunkOffset, zChunk - 1 + chunkOffset]);
        }
    }

    public void SubDensity(int x, int y, int z, float val, bool doVoxelSize)
    {
        if (doVoxelSize)
        {
            x /= (int)voxelSize;
            y /= (int)voxelSize;
            z /= (int)voxelSize;
        }
        int xChunk = x / chunkSize;
        int zChunk = z / chunkSize;

        // Offsets for negative chunks

        int xVert = x % chunkSize;
        int zVert = z % chunkSize;

        if (xVert < 0)
        {
            xVert = chunkSize + xVert;
            xChunk--;
        }
        if (zVert < 0)
        {
            zVert = chunkSize + zVert;
            zChunk--;
        }
        chunksArray[xChunk + chunkOffset, zChunk + chunkOffset].subIsoLevel(xVert, y, zVert, val);
        AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk + chunkOffset]);

        // Update neighbor chunks if we need to
        if (xVert == 0)
        {
            chunksArray[xChunk - 1 + chunkOffset, zChunk + chunkOffset].subIsoLevel(chunkSize, y, zVert, val);
            AddChunkToUpdate(chunksArray[xChunk - 1 + chunkOffset, zChunk + chunkOffset]);
        }
        if (xVert == chunkSize)
        {
            chunksArray[xChunk + 1 + chunkOffset, zChunk + chunkOffset].subIsoLevel(0, y, zVert, val);
            AddChunkToUpdate(chunksArray[xChunk + 1 + chunkOffset, zChunk + chunkOffset]);
        }
        if (zVert == 0)
        {
            chunksArray[xChunk + chunkOffset, zChunk - 1 + chunkOffset].subIsoLevel(xVert, y, chunkSize, val);
            AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk - 1 + chunkOffset]);
        }
        if (zVert == chunkSize)
        {
            chunksArray[xChunk + chunkOffset, zChunk + 1 + chunkOffset].subIsoLevel(xVert, y, 0, val);
            AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk + 1 + chunkOffset]);
        }
        if (xVert == chunkSize && zVert == chunkSize)
        {
            chunksArray[xChunk + 1 + chunkOffset, zChunk + 1 + chunkOffset].subIsoLevel(0, y, 0, val);
            AddChunkToUpdate(chunksArray[xChunk + 1 + chunkOffset, zChunk + 1 + chunkOffset]);
        }
        if (xVert == 0 && zVert == 0)
        {
            chunksArray[xChunk - 1 + chunkOffset, zChunk - 1 + chunkOffset].subIsoLevel(chunkSize, y, chunkSize, val);
            AddChunkToUpdate(chunksArray[xChunk - 1 + chunkOffset, zChunk - 1 + chunkOffset]);
        }
    }

    public void SetDensity(int x, int y, int z, float val, bool doVoxelSize)
    {
        if (doVoxelSize)
        {
            x /= (int)voxelSize;
            y /= (int)voxelSize;
            z /= (int)voxelSize;
        }
        int xChunk = x / chunkSize;
        int zChunk = z / chunkSize;

        // Offsets for negative chunks
        
        int xVert = x % chunkSize;
        int zVert = z % chunkSize;
        
        if (xVert < 0)
        {
            xVert = chunkSize + xVert;
            xChunk--;
        }
        if (zVert < 0)
        {
            zVert = chunkSize + zVert;
            zChunk--;
        }
        
        chunksArray[xChunk+chunkOffset, zChunk + chunkOffset].setIsoLevel(xVert, y, zVert, val);
        AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk + chunkOffset]);
        
        // Update neighbor chunks if we need to
        if (xVert == 0)
        {
            chunksArray[xChunk-1 + chunkOffset, zChunk + chunkOffset].setIsoLevel(chunkSize, y, zVert, val);
            AddChunkToUpdate(chunksArray[xChunk-1 + chunkOffset, zChunk + chunkOffset]);
        }
        if (xVert == chunkSize)
        {
            chunksArray[xChunk + 1 + chunkOffset, zChunk + chunkOffset].setIsoLevel(0, y, zVert, val);
            AddChunkToUpdate(chunksArray[xChunk + 1 + chunkOffset, zChunk + chunkOffset]);
        }
        if (zVert == 0)
        {
            chunksArray[xChunk + chunkOffset, zChunk - 1 + chunkOffset].setIsoLevel(xVert, y, chunkSize, val);
            AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk - 1 + chunkOffset]);
        }
        if (zVert == chunkSize)
        {
            chunksArray[xChunk + chunkOffset, zChunk + 1 + chunkOffset].setIsoLevel(xVert, y, 0, val);
            AddChunkToUpdate(chunksArray[xChunk + chunkOffset, zChunk + 1 + chunkOffset]);
        }
        if (xVert == chunkSize && zVert == chunkSize)
        {
            chunksArray[xChunk + 1 + chunkOffset, zChunk + 1 + chunkOffset].setIsoLevel(0, y, 0, val);
            AddChunkToUpdate(chunksArray[xChunk + 1 + chunkOffset, zChunk + 1 + chunkOffset]);
        }
        if (xVert == 0 && zVert == 0)
        {
            chunksArray[xChunk - 1 + chunkOffset, zChunk - 1 + chunkOffset].setIsoLevel(chunkSize, y, chunkSize, val);
            AddChunkToUpdate(chunksArray[xChunk - 1 + chunkOffset, zChunk - 1 + chunkOffset]);
        }

    }

    public float GetDensity(int x, int y, int z, bool doVoxelSize)
    {
        if (doVoxelSize)
        {
            x /= (int)voxelSize;
            y /= (int)voxelSize;
            z /= (int)voxelSize;
        }
        int xChunk = x / chunkSize;
        int zChunk = z / chunkSize;
        int xVert = x % chunkSize;
        int zVert = z % chunkSize;
        if (xVert < 0)
        {
            xVert = chunkSize + xVert;
            xChunk--;
        }
        if (zVert < 0)
        {
            zVert = chunkSize + zVert;
            zChunk--;
        }
        Debug.Log("Chunk: " + xChunk + ", " + zChunk + ", Vert: " + xVert + ", " + y + ", " + zVert);
        return chunksArray[xChunk + chunkOffset, zChunk + chunkOffset].GetIsoLevel()[xVert, y, zVert];
    }


    public int chunkOffset = 2500;
    // Call everytime the player moves?
    void ChunksAroundPlayer()
    {
        bool doUpdate = false;
        Vector3 chunkedPos = Player.transform.position / (chunkSize * voxelSize);
        for (int z = (int)chunkedPos.z - RenderDistance * 2; z < chunkedPos.z + RenderDistance * 2; z++)
        {
            for (int x = (int)chunkedPos.x - RenderDistance * 2; x < chunkedPos.x + RenderDistance * 2; x++)
            {
                if (Vector3.Distance(new Vector3(chunkedPos.x, 0, chunkedPos.z), new Vector3(x, 0, z)) < RenderDistance)
                {
                    if (chunksArray[x + chunkOffset, z + chunkOffset] == null)
                    {
                        chunksArray[x + chunkOffset, z + chunkOffset] = CreateChunk(x, z);
                        chunks.Add(chunksArray[x + chunkOffset, z + chunkOffset]);
                        chunks[chunks.Count - 1].getGameObject().transform.parent = Terrain.transform;
                        doUpdate = true;

                        // Tree
                        int rand = Random.Range(0, 10);
                        if (rand == 0)
                        {
                            GameObject tree = (GameObject)Instantiate(treePrefab, chunksArray[x + chunkOffset, z + chunkOffset].getGameObject().transform.position + new Vector3(0, 300, 0) - new Vector3(15, 0, 15), Quaternion.identity);
                            chunksArray[x + chunkOffset, z + chunkOffset].AddObject(tree);
                            tree.transform.parent = Terrain.transform;
                        }
                    }
                }
                else
                {
                    if (chunksArray[x + chunkOffset, z + chunkOffset] != null)
                    {
                        chunks.Remove(chunksArray[x + chunkOffset, z + chunkOffset]);
                        chunksArray[x + chunkOffset, z + chunkOffset].Destroy();
                        chunksArray[x + chunkOffset, z + chunkOffset] = null;
                    }
                }
            }
        }
        if (doUpdate)
        {
            UpdateLODs();
        }
    }

    void UpdateLODs()
    {
        foreach (Chunk chunk in chunks)
        {
            float distance = Vector3.Distance(new Vector3(chunk.GetPos().x, 0, chunk.GetPos().z), new Vector3(Player.transform.position.x, 0, Player.transform.position.z));
            if (distance < mediumLodDistance)
            {
                if (chunk.returnLOD() != high_lod)
                {
                    chunk.UpdateLOD(high_lod, voxelSize);
                    AddChunkToUpdate(chunk);
                }
            }
            else if (distance < farLodDistance)
            {
                if (chunk.returnLOD() != med_lod)
                {
                    chunk.UpdateLOD(med_lod, voxelSize);
                    AddChunkToUpdate(chunk);
                }
            }
            else
            {
                if (chunk.returnLOD() != low_lod)
                {
                    chunk.UpdateLOD(low_lod, voxelSize);
                    AddChunkToUpdate(chunk);
                }
            }
            
        }
    }
    

	// Update is called once per frame
	void Update () {
        timer += Time.deltaTime;
        if (timer > 0.05f)
        {
            timer = 0;
            ChunksAroundPlayer();
        }
        if (chunksToUpdate.Count > 0)
        {
            foreach (Chunk chunk in chunksToUpdate)
            {
                chunk.UpdateMesh();
            }
            chunksToUpdate.Clear();
        }
        if (SetLODBool)
        {
            foreach (Chunk chunk in chunks)
            {
                chunk.UpdateLOD(SetLOD, voxelSize);
            }
            SetLODBool = false;
        }
	}
    
}
