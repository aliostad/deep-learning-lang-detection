//encoding utf-8
//author dodge
#include "blockindex.hpp"
#include "chunkwalker.hpp"
#include "terrain.hpp"

namespace Space
{

void ChunkWalker::setChunkIndex( const ChunkIndex & index )
{
    Q_ASSERT( terrain() );
    chunkIndex_ = index;
    if ( const Terrain * terrain = TerrainWalker::terrain() )
    {
        chunkNode_.current = terrain->chunk(index);
        chunkNode_.left = terrain->chunk( index.left() );
        chunkNode_.right = terrain->chunk( index.right() );
        chunkNode_.front = terrain->chunk( index.front() );
        chunkNode_.back = terrain->chunk( index.back() );
    }
}

Block * ChunkWalker::block( BlockIndex index ) const
{
    if (!chunkNode_.current)
        return 0;

    if ( const Terrain * terrain = TerrainWalker::terrain() )
    {
        Chunk * target = chunkNode_.current;
        const Size & chunkSize = terrain->chunkSize();

        // out to height
        if ( index.p[2] < 0 || index.p[2] >= static_cast<qint32>(chunkSize.p[2]) )
        {
            return 0;
        }

        // out to left
        if ( index.p[0] < 0 && chunkNode_.left )
        {
//                 if ( target != current )
//                     return 0;
            index.p[0] = chunkSize.p[0] - index.p[0];
            target = chunkNode_.left;
        }

        // out to right
        if ( index.p[0] >= static_cast<qint32>(chunkSize.p[0]) && chunkNode_.right )
        {
            if ( target != chunkNode_.current )
                return 0;
            index.p[0] = index.p[0] - chunkSize.p[0];
            target = chunkNode_.right;
        }

        // out to back
        if ( index.p[1] < 0 && chunkNode_.back )
        {
            if ( target != chunkNode_.current )
                return 0;
            index.p[1] = chunkSize.p[1] - index.p[1];
            target = chunkNode_.back;
        }

        // out to front
        if ( index.p[1] >= static_cast<qint32>(chunkSize.p[1]) && chunkNode_.front )
        {
            if ( target != chunkNode_.current )
                return 0;
            index.p[1] = index.p[1] - chunkSize.p[1];
            target = chunkNode_.front;
        }

        return target ? target->block( index.plainIndex(chunkSize) ) : 0;
    }
    return 0;
}

}//namespace Space
