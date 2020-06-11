using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TerrainGenerator : MonoBehaviour {
    public int MapWidth, MapHeight;
    private ChunkGenerator ChunkGen = new ChunkGenerator();
    public Transform TileTemplate;
    private GameObject Map;
    private GameObject[] Detectors;
    private bool _performChunkLoad;
    private int _currentChunkPosX, _currentChunkPosY;
    private List<string> _chunkNames;

    void Start()
    {
        _chunkNames = new List<string>();
        Map = new GameObject();
        Detectors = GameObject.FindGameObjectsWithTag("Detector");
        var player = GameObject.FindGameObjectWithTag("Player").transform;
        InitializeChunk(ChunkGen.GenerateChunk(), (int)(player.position.x / ChunkGen.ChunkWidth), (int)(player.position.y / ChunkGen.ChunkHeight));
        ClearSpawn();
        
    }

    void Update()
    {
        RenderChunks();
    }
    void ClearSpawn()
    {
        var player = GameObject.FindGameObjectWithTag("Player").transform;
        for (int i = -2; i < 2; i++)
        {
            for (int j = -2; j < 2; j++)
            {
                DeleteTile(player.position + new Vector3(i, j));
            }
        }
    }
    void RenderChunks()
    {
        foreach (GameObject Detector in Detectors)
        {
            var detectorXPosition = Detector.transform.position.x;
            var detectorYPosition = Detector.transform.position.y;
            if (detectorXPosition < 0)
            {
                detectorXPosition -= ChunkGen.ChunkWidth;
            }
            if (detectorYPosition < 0)
            {
                detectorYPosition -= ChunkGen.ChunkHeight;
            }
            var tempPositionX = (int)detectorXPosition / ChunkGen.ChunkWidth;
            var tempPositionY = (int)detectorYPosition / ChunkGen.ChunkHeight;

            if (tempPositionX != _currentChunkPosX || tempPositionY != _currentChunkPosY)
            {
                InitializeChunk(ChunkGen.GenerateChunk(), tempPositionX, tempPositionY);
                _currentChunkPosX = tempPositionX;
                _currentChunkPosY = tempPositionY;
            }
        }
    }

    public void DeleteMap()
    {
        DestroyImmediate(Map);
    }

    public void InitializeChunk(int[,] chunk, int x, int y)
    {
        if (_chunkNames.Contains(("Chunk_" + x.ToString() + "_" + y.ToString())))
        {
            return;
        }
        var parent = new GameObject();
        parent.transform.SetParent(Map.transform);
        parent.transform.position = new Vector2(x * ChunkGen.ChunkWidth, y * ChunkGen.ChunkHeight);
        parent.name = "Chunk_" +x +"_" +y;
        _chunkNames.Add(parent.name);

        for (int i = 0; i < ChunkGen.ChunkWidth; i++)
        {
            for (int j = 0; j < ChunkGen.ChunkHeight; j++)
            {
                var pos = new Vector2(i, j);
                var tile = (Transform)(Instantiate(TileTemplate, pos, Quaternion.identity));
                tile.SetParent(parent.transform, false);
                tile.name = "Tile_" + i + "_" + j;
                Tile tileScript = tile.GetComponent<Tile>();
                tileScript.TileType = chunk[i, j];
            }
        }
    }
    public void DeleteChunk(int x, int y)
    {
        Destroy(GameObject.Find("Chunk_" + x + "_" + y));
    }
    public void DeleteTile(Vector2 tilePos)
    {
        var chunkX = (int)(tilePos.x / ChunkGen.ChunkWidth);
        var chunkY = (int)(tilePos.y / ChunkGen.ChunkHeight);
        var chunk = GameObject.Find("Chunk_" + chunkX + "_" + chunkY);

        var tileX = (int)(tilePos.x - chunkX * ChunkGen.ChunkWidth);
        var tileY = (int)(tilePos.y - chunkY * ChunkGen.ChunkHeight);
        var tile = chunk.transform.FindChild("Tile_" +tileX  + "_" + tileY);

        Destroy(tile.gameObject);
    }
}
