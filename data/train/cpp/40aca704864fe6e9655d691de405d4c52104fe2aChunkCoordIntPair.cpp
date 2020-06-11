#include "ChunkCoordIntPair.h"


ChunkCoordIntPair(int ChunkCoordIntPair::i, int j) 
{
        chunkXPos = i;
        chunkZPos = j;
}

int ChunkCoordIntPair::chunkXZ2Int(int i, int j) 
{
        return (i >= 0 ? 0 : 0x80000000) | (i & 0x7fff) << 16 | (j >= 0 ? 0 : 0x8000) | j & 0x7fff;
}

int ChunkCoordIntPair::hashCode() 
{
        return chunkXZ2Int(chunkXPos, chunkZPos);
}

boolean ChunkCoordIntPair::equals(Object obj) 
{
        ChunkCoordIntPair chunkcoordintpair = (ChunkCoordIntPair)obj;
        return chunkcoordintpair.chunkXPos == chunkXPos && chunkcoordintpair.chunkZPos == chunkZPos;
}

