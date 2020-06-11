#include "ChunkPosition.h"


ChunkPosition(int ChunkPosition::i, int j, int k) 
{
        x = i;
        y = j;
        z = k;
}

boolean ChunkPosition::equals(Object obj) 
{
        if(obj instanceof ChunkPosition)
        {
            ChunkPosition chunkposition = (ChunkPosition)obj;
            return chunkposition.x == x && chunkposition.y == y && chunkposition.z == z;
        } else
        {
            return false;
        }
}

int ChunkPosition::hashCode() 
{
        return x * 0x88f9fa + y * 0xef88b + z;
}

