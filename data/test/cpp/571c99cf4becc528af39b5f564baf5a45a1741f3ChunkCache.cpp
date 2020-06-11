#include "Utils/Coordinates.h"
#include "dblox/World.h"
#include "dblox/ChunkCache.h"

ChunkCache::ChunkCache( World* World )
    : m_pWorld(World)
{
}

ChunkCache::~ChunkCache()
{
    for( std::map<unsigned int, Chunk*>::iterator Iter = m_Chunks.begin(); Iter != m_Chunks.end(); ++Iter )
    {
        // TODO: Save chunk to disk.
        delete Iter->second;
    }
}

Chunk* ChunkCache::Load( int X, int Z )
{
    std::map<unsigned int, Chunk*>::const_iterator Iter = m_Chunks.find(Utils::GetCantorsPair(X, Z));

    // Chunk is loaded.
    if( Iter == m_Chunks.end() )
        return Iter->second;

    // TODO: Load chunk from disk.

    Chunk* Chunk = new ::Chunk(X, Z, m_pWorld);
    m_pWorld->Generate(X, Z);
    m_Chunks.insert(std::make_pair(Utils::GetCantorsPair(X, Z), Chunk));

    return Chunk;
}

void ChunkCache::Unload( int X, int Z )
{
    std::map<unsigned int, Chunk*>::const_iterator Iter = m_Chunks.find(Utils::GetCantorsPair(X, Z));

    // Chunk isn't loaded.
    if( Iter == m_Chunks.end() )
        return;

    // Save the chunk and unload.
    Chunk* Chunk = Iter->second;
            
    // TODO: Save chunk to disk.

    delete Chunk;
    m_Chunks.erase(Iter);
}