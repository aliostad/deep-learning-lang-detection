//encoding utf-8
//author dodge
#ifndef __ChunkWalker__
#define __ChunkWalker__

#include "chunk.hpp"
#include "chunkindex.hpp"
#include "planenode.hpp"
#include "terrainwalker.hpp"

namespace Space
{

class Block;
class BlockIndex;

class ChunkWalker : public TerrainWalker
{
public:
    inline ChunkIndex chunkIndex() const { return chunkIndex_; }

    void setChunkIndex( const ChunkIndex & index );
    Block * block( BlockIndex index ) const;

private:
    ChunkIndex chunkIndex_;
    PlaneNode<Chunk> chunkNode_;
};

}//namespace Space

#endif//__ChunkWalker__
