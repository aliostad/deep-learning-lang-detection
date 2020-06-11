using UnityEngine;
using System.Collections;

public class Location
{
    World_Location world;
    Chunk_Location chunk;
    int chunkTileWidth = Chunk.getTileWidth();

    [System.Serializable]
    public class MyException : System.Exception
    {
        public MyException() { }
        public MyException(string message) : base(message) { }
        public MyException(string message, System.Exception inner) : base(message, inner) { }
        protected MyException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }

    public Location(int x, int y)
    {
        world = new World_Location(x, y);
        chunk = new Chunk_Location();

        if (world.x >= 0)
        {
            chunk.i = Mathf.FloorToInt(world.x / chunkTileWidth);
            chunk.x = world.x - chunk.i * chunkTileWidth;
        }
        else
        {
            chunk.i = Mathf.CeilToInt((world.x + 1) / chunkTileWidth) - 1;
            chunk.x = (chunkTileWidth - 1) + (world.x + 1)  - (chunk.i + 1) * chunkTileWidth;
        }

        if (world.y >= 0)
        {
            chunk.j = Mathf.FloorToInt(world.y / chunkTileWidth);
            chunk.y = world.y - chunk.j * chunkTileWidth;
        }
        else
        {
            chunk.j = Mathf.CeilToInt((world.y + 1) / chunkTileWidth) - 1;
            chunk.y = (chunkTileWidth - 1) + (world.y + 1) - (chunk.j + 1) * chunkTileWidth;
        }
    }

    public Location(int i, int j, int x, int y)
    {
        
        world = new World_Location();
        chunk = new Chunk_Location(i, j, x, y);

        if (chunk.i >= 0)
        {
            world.x = chunk.i * chunkTileWidth + chunk.x;
        }
        else
        {
            world.x = ((chunk.i + 1) * chunkTileWidth) + (chunk.x - chunkTileWidth);
        }

        if (chunk.j >= 0)
        {
            world.y = chunk.j * chunkTileWidth + chunk.y;
        }
        else
        {
            world.y = ((chunk.j + 1) * chunkTileWidth) + (chunk.y - chunkTileWidth);
        }
    }

    public class World_Location {
    /* Each tile has a coordinate in world space, with origin (0,0) the player spawn location
     * and every newly generated tile position recorded in cartesian fashion. 
     * The origin will be in chunk (0,0) lower left corner tile; (0,0) in chunk coordinates. */

        public int x;
        public int y;

        public World_Location()
        {
            this.x = 0;
            this.y = 0;
        }

        public World_Location(int x, int y) 
        {
            this.x = x;
            this.y = y;
        }

    }

    public class Chunk_Location
    /* Tiles divided into chunks. Each chunk has a column and row (i,j) and each tile within are designated chunk coordinates (x,y)
     * with (0,0) being the lower left tile.
     * World origin (0,0) would be in Chunk (0,0) in the lower left corner tile (0,0). */
    {
        public int i;
        public int j;
        public int x;
        public int y;

        public Chunk_Location()
        {
            this.i = 0;
            this.j = 0;
            this.x = 0;
            this.y = 0;
        }

        public Chunk_Location(int i, int j, int x, int y)
        {
            this.i = i;
            this.j = j;
            this.x = x;
            this.y = y;
        }
    }

    public int WorldX()
    {
        return world.x;
    }

    public int WorldY()
    {
        return world.y;
    }

    public int ChunkI()
    {
        return chunk.i;
    }

    public int ChunkJ()
    {
        return chunk.j;
    }

    public int ChunkX()
    {
        return chunk.x;
    }

    public int ChunkY()
    {
        return chunk.y;
    }

    public Chunk_Location ChunkL()
    {
        return chunk;
    }

    public World_Location World()
    {
        return world;
    }
}
