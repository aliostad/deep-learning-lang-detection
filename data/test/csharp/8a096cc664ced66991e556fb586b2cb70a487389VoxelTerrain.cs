using UnityEngine;
using System.Linq;
using System.Collections.Generic;
using System.IO;

[ExecuteInEditMode]
public class VoxelTerrain : MonoBehaviour
{
    public List<BlockType> BlockTypes = new List<BlockType>();

    public Dictionary<Vector3, Chunk> Chunks = new Dictionary<Vector3, Chunk>();
    public string LevelName;

	// Use this for initialization
	void Start ()
    {

    }

    public void SetVoxel(int x, int y, int z, Voxel voxel)
    {
        var chunk = GetChunk(x, y, z);

        var localX = (byte)(x - chunk.ChunkPosition.x);
        var localY = (byte)(y - chunk.ChunkPosition.y);
        var localZ = (byte)(z - chunk.ChunkPosition.z);

        chunk.SetVoxel(localX, localY, localZ, voxel);
    }
    public Voxel GetVoxel(int x, int y, int z)
    {
        var chunk = GetChunk(x, y, z);

        var localX = (byte)(x - chunk.ChunkPosition.x);
        var localY = (byte)(y - chunk.ChunkPosition.y);
        var localZ = (byte)(z - chunk.ChunkPosition.z);

        Voxel result = Voxel.Empty;
        chunk.GetVoxel(localX, localY, localZ, ref result);
        return result;
    }

    public void Clear()
    {
        var foundChunks = GetComponentsInChildren<Chunk>();
        foreach (var chunk in foundChunks)
        {
            var chunkRender = chunk.GetComponent<ChunkRender>();
            chunkRender.Clear();

            DestroyImmediate(chunk.gameObject);
        }
        Chunks.Clear();
    }

    public void RenderAll(bool onlyDirty = false)
    {
        var foundChunks = GetComponentsInChildren<Chunk>();
        foreach (var chunk in foundChunks)
        {
            var chunkRender = chunk.GetComponent<ChunkRender>();
            if (chunkRender == null)
            {
                chunkRender = chunk.gameObject.AddComponent<ChunkRender>();
            }
            chunkRender.RenderChunk(onlyDirty);

            Chunks[chunk.ChunkPosition] = chunk;
        }
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        var worldX = Mathf.Floor(x / 8f);
        var worldY = Mathf.Floor(y / 8f);
        var worldZ = Mathf.Floor(z / 8f);

        var pos = new Vector3(worldX * 8f, worldY * 8f, worldZ * 8f);
        Chunk chunk;
        if (!Chunks.TryGetValue(pos, out chunk))
        {
            var chunkObj = new GameObject();
            chunkObj.transform.parent = transform;
            chunkObj.name = "chunk_" + worldX + "_" + worldY + "_" + worldZ;
            Chunks[pos] = chunk = chunkObj.AddComponent<Chunk>();

            chunk.ChunkPosition = pos;
            chunk.Parent = this;
            chunk.transform.position = pos;

            var chunkRender = chunkObj.AddComponent<ChunkRender>();
        }

        if (!chunk.Loaded)
        {
            chunk.ChunkPosition = pos;
            chunk.Parent = this;
            chunk.transform.position = pos;
            chunk.Loaded = true;
            var filename = string.Format("{0}.{1}.{2}.chunk",  pos.x, pos.y, pos.z);
            var filepath = Path.Combine(VoxelLoader.LevelPath(LevelName), filename);

            if (File.Exists(filepath))
            {
                Debug.Log("Chunk not loaded, pulling from: " + filepath);
                ChunkSerializer.Deserialize(chunk, filepath);
            }
            else
            {
                Debug.Log("Skipping load chunk as file does not exist: " + filepath);
            }
        }

        return chunk;
    }
}
