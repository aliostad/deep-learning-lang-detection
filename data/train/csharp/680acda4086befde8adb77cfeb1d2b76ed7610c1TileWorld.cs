using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TileWorld : MonoBehaviour
{

    public Dictionary<TileWorldPos, TileChunk> chunks = new Dictionary<TileWorldPos, TileChunk>();

    private TileModifyTerrain ModifyTerrain = new TileModifyTerrain();

    int[,] map;

    public static int WorldX = 60;
    public static int WorldY = 40;

    public static int WorldSizeInPixelsX = (WorldX * 2) * 16 + 16;
    public static int WorldSizeInPixelsY = (WorldY * 2) * 16 + 16;

    public GameObject TileChunkPrefab;

    void Start()
    {
        for (int x = 0; x < WorldX; x++)
        {
            for (int y = 0; y < WorldY; y++)
            {
                CreateTileChunk(x * 16, y * 16);
            }
        }

        ModifyTerrain.ModifyTerrain(this);
    }

    public void CreateTileChunk(int x, int y)
    {

        TileWorldPos worldPos = new TileWorldPos(x, y);

        GameObject newTileChunkObject = Instantiate(TileChunkPrefab, new Vector3(x, y, 0), Quaternion.identity) as GameObject;

        TileChunk newChunk = newTileChunkObject.GetComponent<TileChunk>();

        newChunk.pos = worldPos;
        newChunk.World = this;

        chunks.Add(worldPos, newChunk);

        for (int xi = 0; xi < 16; xi++)
        {
            for (int yi = 0; yi < 16; yi++)
            {
                SetTile(x + xi, y + yi, new TileAir());
            }
        }

        var terrainGen = new TileTerrainGeneration();
        newChunk = terrainGen.ChunkGen(newChunk);
        newChunk.SetTileUnmodified();
    }

    public void DestoryTileChunk(int x, int y)
    {
        TileChunk Chunk = null;
        if (chunks.TryGetValue(new TileWorldPos(x, y), out Chunk))
        {
            Destroy(Chunk.gameObject);
            chunks.Remove(new TileWorldPos(x, y));
        }
    }

    public TileChunk GetChunk(int x, int y)
    {
        TileWorldPos pos = new TileWorldPos();
        float multipleX = TileChunk.ChunkSizeX;
        float multipleY = TileChunk.ChunkSizeY;

        pos.x = Mathf.FloorToInt(x / multipleX) * TileChunk.ChunkSizeX;
        pos.y = Mathf.FloorToInt(y / multipleY) * TileChunk.ChunkSizeY;

        TileChunk containerChunk = null;
        chunks.TryGetValue(pos, out containerChunk);

        return containerChunk;
    }

    public Tile GetTile(int x, int y)
    {
        TileChunk containerChunk = GetChunk(x, y);
        if (containerChunk != null)
        {
            Tile tile = containerChunk.GetTile(x - containerChunk.pos.x, y - containerChunk.pos.y);
            return tile;
        }
        else
        {
            return new TileAir();
        }
    }

    void UpdateIfEqual(int value1, int value2, TileWorldPos pos)
    {
        if (value1 == value2)
        {
            TileChunk chunk = GetChunk(pos.x, pos.y);
            if (chunk != null)
            {
                chunk.ChunkUpdate = true;
            }
        }
    }

    public void SetTile(int x, int y, Tile tile)
    {
        TileChunk chunk = GetChunk(x, y);

        if (chunk != null)
        {
            chunk.SetTile(x - chunk.pos.x, y - chunk.pos.y, tile);
            chunk.ChunkUpdate = true;

            UpdateIfEqual(x - chunk.pos.x, 0, new TileWorldPos(x - 1, y));
            UpdateIfEqual(x - chunk.pos.x, TileChunk.ChunkSizeX - 1, new TileWorldPos(x + 1, y));
            UpdateIfEqual(y - chunk.pos.y, 0, new TileWorldPos(x, y - 1));
            UpdateIfEqual(y - chunk.pos.y, TileChunk.ChunkSizeY - 1, new TileWorldPos(x, y + 1));
        }
    }
}
