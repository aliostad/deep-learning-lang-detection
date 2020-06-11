using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SharpVoxel;
public class Map : MonoBehaviour {
    public Dictionary<VoxelPosition, Chunk> loadedChunks = new Dictionary<VoxelPosition, Chunk>();
    public GameObject chunkPrefab;
	public MaterialList mapMaterials;
    float scaleFactor = 1;
    int chunkSize = 16;

    public void SpawnChunk(int x, int y, int z)
    {
        VoxelPosition worldPos = new VoxelPosition(x, y, z);

        if (loadedChunks.ContainsKey(worldPos)) { return; }

        //Instantiate the chunk at the coordinates using the chunk prefab
        GameObject newChunkObject = Instantiate(
                        chunkPrefab, new Vector3(x * scaleFactor, y * scaleFactor, z * scaleFactor),
                        Quaternion.Euler(Vector3.zero),
                        this.transform
                    ) as GameObject;

        newChunkObject.name = "Chunk at (" + x + ", " + y + ", " + z + ")";

        Chunk newChunk = newChunkObject.GetComponent<Chunk>();

        newChunk.position = worldPos;
        newChunk.map = this;
        newChunk.MoveIntoPlace();
        newChunk.scaleFactor = scaleFactor;
        newChunk.chunkSize = chunkSize;
        loadedChunks.Add(worldPos, newChunk);
    }

    public VoxelData GetVoxel(int x, int y, int z)
    {
        Chunk containerChunk = GetChunk(x, y, z);
        if (containerChunk != null)
        {
            VoxelData voxel = containerChunk[
                x - containerChunk.position.x,
                y - containerChunk.position.y,
                z - containerChunk.position.z];

            return voxel;
        }
        else
        {
            return new VoxelData(0);
        }
    }

    public void SetVoxel(int x, int y, int z, VoxelData voxel)
    {
        Chunk chunk = GetChunk(x, y, z);

        if (chunk == null) { return; }

        chunk[x - chunk.position.x, y - chunk.position.y, z - chunk.position.z] = voxel;

        UpdateIfEqual(x - chunk.position.x, 0, new VoxelPosition(x - 1, y, z));
        UpdateIfEqual(x - chunk.position.x, chunkSize - 1, new VoxelPosition(x + 1, y, z));
        UpdateIfEqual(y - chunk.position.y, 0, new VoxelPosition(x, y - 1, z));
        UpdateIfEqual(y - chunk.position.y, chunkSize - 1, new VoxelPosition(x, y + 1, z));
        UpdateIfEqual(z - chunk.position.z, 0, new VoxelPosition(x, y, z - 1));
        UpdateIfEqual(z - chunk.position.z, chunkSize - 1, new VoxelPosition(x, y, z + 1));
    }

    public Chunk GetChunk(int x, int y, int z)
    {
        VoxelPosition pos = new VoxelPosition();
        float multiple = chunkSize;
        pos.x = Mathf.FloorToInt(x / multiple) * chunkSize;
        pos.y = Mathf.FloorToInt(y / multiple) * chunkSize;
        pos.z = Mathf.FloorToInt(z / multiple) * chunkSize;
        Chunk containerChunk = null;
        loadedChunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }

    private void UpdateIfEqual(int value1, int value2, VoxelPosition pos)
    {
        if (value1 == value2)
        {
            Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null) chunk.ForceUpdate();
        }
    }

    private void Start()
    {
        for (int x = -4; x < 4; x++)
        {
            for (int y = 0; y < 1; y++)
            {
                for (int z = -4; z < 4; z++)
                {
                    SpawnChunk(x * chunkSize, y * chunkSize, z * chunkSize);
                }
            }
        }
    }

}
