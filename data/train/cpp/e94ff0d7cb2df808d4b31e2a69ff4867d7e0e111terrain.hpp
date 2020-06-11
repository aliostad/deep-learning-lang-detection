//encoding utf-8
//author dodge
#ifndef __Terrain__
#define __Terrain__

#include <QtCore/QMap>
#include <QtCore/QRect>

#include "chunkindex.hpp"

class QRect;

namespace Space
{

class AbstractChunkDataProvider;
class Block;
class BlockIndex;
class Chunk;
class Size;

class Terrain
{
public:
    Terrain();

    Chunk * chunk( const ChunkIndex & index ) const;
    Block * block( const BlockIndex & index ) const;
    const Size & chunkSize() const;
    const QRect & chunksRect() const;

    void setVisibleRect( const QRect & rect );
    void setChunkSize( const Size & size );

    static void test();

private:
    Chunk * ensureChunk( const ChunkIndex & index );

    Size chunkSize_;
    QMap<ChunkIndex,Chunk*> chunks_;
    AbstractChunkDataProvider * chunkDataProvider_;
    QRect chunksRect_;

};

}//namespace Space

#endif//__Terrain__
