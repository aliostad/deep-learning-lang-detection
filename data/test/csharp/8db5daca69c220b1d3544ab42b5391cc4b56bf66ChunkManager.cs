using System;
using System.Collections.Generic;
using UnityEngine;

namespace MonsterAdventure
{
    public class ChunkManager : MonoBehaviour
    {
        public uint chunkSize = 100;

        public bool drawGrid = true;
        public bool drawDistance = false;
        public bool drawColor = true;

        public Chunk chunkPrefab;
        public Tile tilePrefab;
        public BiomeManager biomeManger;

        private List<List<Chunk>> _chunks;

        public void Construct(int size)
        {
            Vector2 mapSize;
            mapSize.x = size;
            mapSize.y = size;

            Chunk.size = chunkSize;
            Chunk.tilePrefab = tilePrefab;

            _chunks = new List<List<Chunk>>();

            Vector2 offset = (mapSize * chunkSize - new Vector2(chunkSize, chunkSize)) / 2;

            for (int i = 0; i < mapSize.x; i++)
            {
                _chunks.Add(new List<Chunk>());

                for (int j = 0; j < mapSize.y; j++)
                {
                    _chunks[i].Add(InstantiateChunk(chunkPrefab, i, j));

                    Vector2 chunkPosition;
                    chunkPosition.x = i * chunkSize - offset.x;
                    chunkPosition.y = j * chunkSize - offset.y;

                    _chunks[i][j].transform.position = chunkPosition;
                }
            }
        }

        public Chunk Get(int x, int y)
        {
            if (0 <= x && x < _chunks.Count
                && 0 <= y && y < _chunks[0].Count)
            {
                return _chunks[(int)x][(int)y];
            }

            return null;
        }

        public uint GetLength(uint index)
        {
            if (index == 0)
                return (uint) _chunks.Count;

            return (uint) _chunks[0].Count;
        }

        private Chunk InstantiateChunk(Chunk prefab, int x, int y)
        {
            Chunk chunk = Instantiate<Chunk>(prefab);
            chunk.transform.parent = gameObject.transform;
            chunk.name = prefab.name + " (" + x + ", " + y + ")";
            chunk.SetPositionInGrid(x, y);

            return chunk;
        }

        public List<List<Chunk>> GetChunks()
        {
            return _chunks;
        }
    }
}