using System;
using System.Collections.Generic;
using Assets.Core.Coordinates;

namespace Assets.Core
{
    

    [Serializable]
    public class Save
    {
        public Dictionary<TilePos, Tile> tiles = new Dictionary<TilePos, Tile>();


        public Save(Chunk chunk)
        {
            for (int x = 0; x < Chunk.CHUNK_WIDTH; x++) {
                for (int y = 0; y < Chunk.CHUNK_HEIGHT; y++) {
                    for (int z = 0; z < Chunk.CHUNK_DEPTH; z++) {
                        if (!chunk.tiles[x,y, z].modified) continue;
                    
                        TilePos pos = new TilePos(x, y, z);
                        tiles.Add(pos, chunk.tiles[x, y, z]);
                    }
                }
            }
        }
        
    }
}