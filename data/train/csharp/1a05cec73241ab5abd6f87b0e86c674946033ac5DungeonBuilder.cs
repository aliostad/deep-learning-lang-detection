using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class DungeonBuilder : MonoBehaviour
{
    public List<Material> blocks = new List<Material>();
    public List<GameObject> items = new List<GameObject>();
    public List<Rule> rules = new List<Rule>();
    public int selected = 0;
    public bool autoRemesh = true;
    public bool shiftToDelete = true;

    private void Awake()
    {
        Destroy(this);
    }

    public void Clear()
    {
        for (int i = transform.childCount - 1; i >= 0; i--)
            DestroyImmediate(transform.GetChild(i).gameObject);
    }

    private Chunk GetChunk(Transform r, int chunkX, int chunkY, int chunkZ, int type, bool create)
    {
        if (r == null)
            return null;

        Chunk c;
        int childCount = r.childCount;
        for (int i = 0; i < childCount; i++)
        {
            c = r.GetChild(i).GetComponent<Chunk>();
            if (c == null)
                continue;
            if (c.chunkX == chunkX && c.chunkY == chunkY && c.chunkZ == chunkZ)
                return c;
        }

        if (!create)
            return null;

        GameObject go = new GameObject();
        go.name = string.Format("Chunk [{0}, {1}, {2}]", chunkX, chunkY, chunkZ);
        go.isStatic = true;
        go.layer = 8; // Layer 8; Chunks
        go.transform.SetParent(r, true);
        go.transform.localPosition = new Vector3(chunkX, chunkY, chunkZ) * Chunk.CHUNK_SIZE;

        Mesh mesh = new Mesh();
        mesh.name = string.Format("ChunkMesh [{0}, {1}, {2}; {3}]", chunkX, chunkY, chunkZ, type);

        go.AddComponent<MeshFilter>().sharedMesh = mesh;
        MeshRenderer meshRen = go.AddComponent<MeshRenderer>();
        meshRen.material = blocks[type] as Material;
        EditorUtility.SetSelectedRenderState(meshRen, EditorSelectedRenderState.Hidden);
        go.AddComponent<MeshCollider>().sharedMesh = mesh;
        c = go.AddComponent<Chunk>();
        c.chunkX = chunkX;
        c.chunkY = chunkY;
        c.chunkZ = chunkZ;
        c.dungeon = this;
        return c;
    }

    private Transform GetRegion(Transform g, int chunkX, int chunkY, int chunkZ, bool create)
    {
        if (g == null)
            return null;
        
        chunkX /= 4;
        chunkY /= 4;
        chunkZ /= 4;

        BlockTypeGroup r;
        int childCount = g.childCount;
        for (int i = 0; i < childCount; i++)
        {
            r = g.GetChild(i).GetComponent<BlockTypeGroup>();
            if (r == null)
                continue;
            if (r.chunkX == chunkX && r.chunkY == chunkY && r.chunkZ == chunkZ)
                return r.transform;
        }

        if (!create)
            return null;

        GameObject go = new GameObject();
        go.name = string.Format("Region [{0}, {1}, {2}]", chunkX, chunkY, chunkZ);
        go.isStatic = true;
        go.transform.SetParent(g, true);
        r = go.AddComponent<BlockTypeGroup>();
        r.chunkX = chunkX;
        r.chunkY = chunkY;
        r.chunkZ = chunkZ;
        return go.transform;
    }

    private Transform GetGroup(int type, bool create)
    {
        Material material = blocks[type] as Material;
        int childCount = transform.childCount;
        for (int i = 0; i < childCount; i++)
        {
            BlockTypeGroup g = transform.GetChild(i).GetComponent<BlockTypeGroup>();
            if (g == null)
                continue;
            if (g.block == material)
                return g.transform;
        }

        if (!create)
            return null;

        GameObject go = new GameObject();
        go.name = "BlockType " + (blocks[type] as Material).name;
        go.isStatic = true;
        go.transform.SetParent(transform, true);
        go.AddComponent<BlockTypeGroup>().block = material;
        return go.transform;
    }

    private Chunk GetChunk(int chunkX, int chunkY, int chunkZ, int type, bool create)
    {
        Transform g = GetGroup(type, create);
        Transform r = GetRegion(g, chunkX, chunkY, chunkZ, create);
        return GetChunk(r, chunkX, chunkY, chunkZ, type, create);
    }

    public void SetBlock(int x, int y, int z, int block)
    {
        int chunkX = x >> Chunk.CHUNK_BITS;
        int chunkY = y >> Chunk.CHUNK_BITS;
        int chunkZ = z >> Chunk.CHUNK_BITS;
        Chunk chunk;

        if (block == -1)
        {
            for (int i = 0; i < blocks.Count; i++)
            {
                chunk = GetChunk(chunkX, chunkY, chunkZ, i, false);
                if (chunk != null)
                    chunk.SetBlock(x, y, z, false);
            }
        }
        else
        {
            chunk = GetChunk(chunkX, chunkY, chunkZ, block, true);
            chunk.SetBlock(x, y, z, true);
        }
    }

    public void RemeshAll()
    {
        Chunk[] chunks = transform.GetComponentsInChildren<Chunk>();
        foreach (Chunk c in chunks)
            c.UpdateMesh();
    }

    public void FillBlocks(int x1, int y1, int z1, int x2, int y2, int z2, int block)
    {
        Vector3 p1 = new Vector3(x1 >> Chunk.CHUNK_BITS, y1 >> Chunk.CHUNK_BITS, z1 >> Chunk.CHUNK_BITS);
        Vector3 p2 = new Vector3(x2 >> Chunk.CHUNK_BITS, y2 >> Chunk.CHUNK_BITS, z2 >> Chunk.CHUNK_BITS);
        Vector3 min = Vector3.Min(p1, p2);
        Vector3 max = Vector3.Max(p1, p2);

        Chunk chunk;
        int a, b, c, i;
        for (a = (int)min.x; a <= max.x; a++)
            for (b = (int)min.y; b <= max.y; b++)
                for (c = (int)min.z; c <= max.z; c++)
                {
                    if (block == -1)
                    {
                        for (i = 0; i < blocks.Count; i++)
                        {
                            chunk = GetChunk(a, b, c, i, false);
                            if (chunk != null)
                                chunk.FillBlocks(x1, y1, z1, x2, y2, z2, false);
                        }
                    }
                    else
                        GetChunk(a, b, c, block, true).FillBlocks(x1, y1, z1, x2, y2, z2, true);
                }
    }
}
