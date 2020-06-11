using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkManager : MonoBehaviour {

    private Dictionary<Chunk.ChunkPosition, Chunk> chunks = new Dictionary<Chunk.ChunkPosition, Chunk>();

    public GameObject chunkPrefab;

    public ChunkLoadQueue chunkQueue;

    public Transform chunkParent;

    void Start()
    {
        System.Threading.ThreadPool.SetMinThreads(64, 64);
        System.Threading.ThreadPool.SetMaxThreads(64, 64);
        /*
        for (int x = -2; x < 2; x++)
        {
            for (int y = 0; y < 2; y++)
            {
                for (int z = -1; z < 1; z++)
                {
                    CreateChunk(x, y, z, new byte[8192], new byte[8192]);
                }
            }
        }
        */
    }

    public void CreateChunk(int x, int y, int z, byte[] ids)
    {
        string chunkName = Chunk.Key(x, y, z);
        Object existChunk = chunkParent.Find(chunkName);
        if (existChunk != null)
        {
            Destroy(chunkParent.Find(chunkName).gameObject);
        }
        Chunk.ChunkPosition pos = new Chunk.ChunkPosition(x, y, z);

        GameObject chunkObject = Instantiate(chunkPrefab, new Vector3(x << 4, y << 4, z << 4), Quaternion.Euler(Vector3.zero), chunkParent);
        chunkObject.name = chunkName;
        Chunk chunk = chunkObject.GetComponent<Chunk>();
        chunk.chunkManager = this;
        chunk.position = pos;

        chunk.blocks = ids;//new byte[Chunk.chunkSize * Chunk.chunkSize * Chunk.chunkSize * 2];

        UpdateRelations(chunk);

        chunk.update = true;
        
        MarkUpdate(x + 1, y, z);
        MarkUpdate(x - 1, y, z);
        MarkUpdate(x, y, z + 1);
        MarkUpdate(x, y, z - 1);
        MarkUpdate(x, y + 1, z);
        MarkUpdate(x, y - 1, z);
    }

    public int getBlockAt(int x, int y, int z)
    {
        int cx = x >> 4;
        int cy = y >> 4;
        int cz = z >> 4;
        Transform t = chunkParent.Find(Chunk.Key(cx, cy, cz));
        if (t == null) return 0;
        return t.GetComponent<Chunk>().GetBlock(x & 0xF, y & 0xF, z & 0xF);
    }

    public void setBlockAt(int x, int y, int z, int id)
    {
        int cx = x >> 4;
        int cy = y >> 4;
        int cz = z >> 4;
        Chunk c = getChunk(cx, cy, cz);
        if (c == null)
        {
            CreateChunk(cx, cy, cz, new byte[2 * 16 * 16 * 16]);
            c = getChunk(cx, cy, cz);
        }

        int bx = x & 0xF;
        int by = y & 0xF;
        int bz = z & 0xF;
        c.SetBlock(bx, by, bz, id);

        c.forceUpdate = true;
        foreach(Chunk rel in c.relations)
        {
            if (rel != null) rel.forceUpdate = true;
        }
    }

    public void UpdateRelations(Chunk chunk)
    {
        int x = chunk.position.x;
        int y = chunk.position.y;
        int z = chunk.position.z;
        // Create relations
        Transform relationUp = chunkParent.Find(Chunk.Key(x, y + 1, z));
        if (relationUp != null)
        {
            chunk.relations[4] = relationUp.gameObject.GetComponent<Chunk>();
            chunk.relations[4].relations[5] = chunk;
        }


        Transform relationDown = chunkParent.Find(Chunk.Key(x, y - 1, z));
        if (relationDown != null)
        {
            chunk.relations[5] = relationDown.gameObject.GetComponent<Chunk>();
            chunk.relations[5].relations[4] = chunk;
        }

        Transform relationNorth = chunkParent.Find(Chunk.Key(x, y, z + 1));
        if (relationNorth != null)
        {
            chunk.relations[0] = relationNorth.gameObject.GetComponent<Chunk>();
            chunk.relations[0].relations[2] = chunk;
        }

        Transform relationEast = chunkParent.Find(Chunk.Key(x + 1, y, z));
        if (relationEast != null)
        {
            chunk.relations[1] = relationEast.gameObject.GetComponent<Chunk>();
            chunk.relations[1].relations[3] = chunk;
        }

        Transform relationSouth = chunkParent.Find(Chunk.Key(x, y, z - 1));
        if (relationSouth != null)
        {
            chunk.relations[2] = relationSouth.gameObject.GetComponent<Chunk>();
            chunk.relations[2].relations[0] = chunk;
        }

        Transform relationWest = chunkParent.Find(Chunk.Key(x - 1, y, z));
        if (relationWest != null)
        {
            chunk.relations[3] = relationWest.gameObject.GetComponent<Chunk>();
            chunk.relations[3].relations[1] = chunk;
        }
    }

    public void MarkUpdate(int x, int y, int z)
    {
        Transform t = chunkParent.Find("chunk|" + x + "|" + y + "|" + z);
        if (t == null) return;
        
        t.GetComponent<Chunk>().update = true;
    }

    public Chunk getChunk(int x, int y, int z)
    {
        Transform t = chunkParent.Find("chunk|" + x + "|" + y + "|" + z);
        if (t == null) return null;
        return t.GetComponent<Chunk>();
    }
}
