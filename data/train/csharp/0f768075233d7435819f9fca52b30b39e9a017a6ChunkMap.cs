using UnityEngine;
using System.Collections.Generic;

public class ChunkMap : MonoBehaviour
{
    public Dictionary<IntVec3, ChunkData> Chunks = new Dictionary<IntVec3, ChunkData>();
    public GameObject ChunkPrefab;

    public ChunkData EnsureChunk(IntVec3 chunkCoord)
    {
        ChunkData cd;
        if (!Chunks.TryGetValue(chunkCoord, out cd))
        {
            var go = (GameObject)Instantiate(ChunkPrefab, Constants.ChunkSize * chunkCoord.NegativeCornersToVector3(), Quaternion.identity);
            go.transform.SetParent(transform, false);
            go.name = string.Format("Chunk @ {0},{1},{2}", chunkCoord.x, chunkCoord.y, chunkCoord.z);
            cd = go.GetComponent<ChunkData>();
            Chunks.Add(chunkCoord, cd);
        }

        return cd;
    }

    public ChunkData GetChunk(IntVec3 chunkCoord)
    {
        ChunkData cd;
        Chunks.TryGetValue(chunkCoord, out cd);
        return cd;
    }

    public void Start()
    {
        var ce = EnsureChunk(new IntVec3(0, 0, 0));

        // some initial data
        ce.Contents[3, 0, 3] = 1;
        ce.Contents[3, 0, 4] = 1;
        ce.Contents[3, 1, 4] = 1;
    }
}
