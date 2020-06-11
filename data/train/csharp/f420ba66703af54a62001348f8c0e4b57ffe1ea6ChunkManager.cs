using System.Collections.Generic;
using ClipperLib;
using UnityEngine;

public static class ChunkManager {

    static bool dirtyChunks = false;
    static Dictionary<IntPoint, MapChunk> chunks = new Dictionary<IntPoint, MapChunk>();
    static List<MapChunk> dirtyList = new List<MapChunk>();
    static IntPoint pointer = new IntPoint(-1, -1);
    public static GameObject MapChunks;

    public static MapChunk CreateChunk (int x, int y)
    {
        MapChunk chunk = new MapChunk(x, y);
        chunks.Add(chunk.pos, chunk);
        chunk.gameobject.transform.parent = MapChunks.transform;
        chunk.gameobject.transform.position = new Vector3(x * MapChunk.chunkSize, y * MapChunk.chunkSize, 0);
        return chunk;
    }

    public static MapChunk GetChunk(int x, int y)
    {
        pointer.X = x;
        pointer.Y = y;

        if (chunks.ContainsKey(pointer))
            return chunks[pointer];

        return null;
    }

    public static void SpawnChunks ()
    {
        int widthInChunks = MapGenerator.instance.Map.width / MapChunk.chunkSize;
        int heightInChunks = MapGenerator.instance.Map.height / MapChunk.chunkSize;

        for(int y = 0; y < heightInChunks;y++)
        {
            for(int x = 0; x < widthInChunks;x++)
            {
                MapChunk chunk = CreateChunk(x, y);
                PolyGen.Generate(chunk);
            }
        }

        Debug.Log(string.Format("ChunksWidth : {0}  ChunksHeight : {1}", widthInChunks, heightInChunks));

    }

    public static void Dirty (MapChunk chunk)
    {
        if (dirtyList.Contains(chunk))
            return;

        dirtyList.Add(chunk);
        dirtyChunks = true;
    }

    public static void Redraw ()
    {
        if (!dirtyChunks)
            return;

        foreach(MapChunk chunk in dirtyList)
        {
            PolyGen.Generate(chunk);
        }
        dirtyList.Clear();
        dirtyChunks = false;
    }
}
