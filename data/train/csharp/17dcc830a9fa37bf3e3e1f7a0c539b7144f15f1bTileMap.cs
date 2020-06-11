using Assets.Scripts.Model.Position;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets.Scripts.Model.Tiles
{
    class TileMap
    {
        private const int ChunkSize = 1000;

        private TileChunkCache chunkCache = new TileChunkCache();

        public float Resolution { get; private set; }

        public TileMap()
        {
            Resolution = 1f;
        }

        public void LoadChunk(Coordinate position, int width, int height, Tile[] targetTiles)
        {
            var chunkId = GetChunkId(position);
            var chunk = chunkCache.LoadTileChunk(chunkId);

            var chunkX = chunk.Position.X;
            var chunkY = chunk.Position.Y;

            for (var y = 0; y < height; ++y)
            {
                for (var x = 0; x < width; ++x)
                {
                    var newChunkId = GetChunkId(new Coordinate(position.X + x, position.Y + y));
                    if (chunkId != newChunkId)
                    {
                        chunk = chunkCache.LoadTileChunk(chunkId);
                        chunkId = newChunkId;
                    }
                    targetTiles[x + y * width] = chunk.GetTile(position.X + x, position.Y + y);
                }
            }
        }

        private static long GetChunkId(Coordinate position)
        {
            var chunkX = position.X / ChunkSize;
            var chunkY = position.Y / ChunkSize;

            return chunkX << 32 | chunkY;
        }
    }
}
