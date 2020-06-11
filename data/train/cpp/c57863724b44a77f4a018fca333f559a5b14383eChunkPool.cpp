/**
 * @file
 * @author LKostyra (costyrra.xl@gmail.com)
 * @brief  Chunk Pool definitions
 */

#include "ChunkPool.hpp"


ChunkPool::ChunkPool()
{
}

ChunkPool::~ChunkPool()
{
    for (auto& chunk : mChunks)
        chunk.second.SaveToDisk();
}

Chunk* ChunkPool::GetChunk(int x, int z)
{
    ChunkKeyType key(x, z);

    auto chunkIt = mChunks.find(key);
    if (chunkIt == mChunks.end())
    {
        // chunk not found - add it to the pool and reacquire the iterator
        auto itPair = mChunks.emplace(std::make_pair(key, Chunk()));
        chunkIt = itPair.first;
    }

    return &chunkIt->second;
}
