#include "ChunkManager.h"
#include "Chunk.h"
#include <string>
#include <sstream>
#include <iostream>
#include <mutex>
#include "Block.h"

ChunkManager::ChunkManager()
{

}

void ChunkManager::AsyncChunkLoad(int chunkX, int chunkY, int chunkZ)
{
  
}

void ChunkManager::AsyncChunkUnload(Chunk** chunks, int num)
{
  if(loadLive == false)
  {

  }
}

void ChunkManager::UnloadChunk(Chunk* chunk)
{
  static int chunkX(0), chunkY(0), chunkZ(0);
  unloadMutex.lock();

  chunkX = (int)chunk->WorldPosition().x;
  chunkY = (int)chunk->WorldPosition().y;
  chunkZ = (int)chunk->WorldPosition().z;

  std::stringstream fNameStream;
  fNameStream << chunkX << "_" << chunkY << "_" << chunkZ << ".dat";
  writeStream.open(fNameStream.str().c_str(), std::ios::binary | std::ios::beg | std::ios::out);

  writeStream.put(ChunkTags::Start);

  // Write the position to the stream.
  writeStream.put(ChunkTags::Position);
  writeStream.put(sizeof(int) * 3);
  int pos[3] = { chunkX, chunkY, chunkZ };
  writeStream.write((char*)pos, sizeof(int) * 3);
  
  // Write the chunk size configuration.
  writeStream.put(ChunkTags::ChunkSize);
  writeStream.put(sizeof(int));
  writeStream.put(gkChunkSize);

  // Write block data.
  writeStream.put(ChunkTags::BlockData);
  int bBlocksSize = sizeof(BlockTypes) * gkChunkSize * gkChunkSize * gkChunkSize;
  writeStream.write((char*)&bBlocksSize, sizeof(int));
  for(int x = 0; x < gkChunkSize; ++x)
  {
    for(int z = 0; z < gkChunkSize; ++z)
    {
      writeStream.write((char*)chunk->blocks[x][z], sizeof(BlockTypes) * gkChunkSize);
    }
  }
  writeStream.put(ChunkTags::End);
  
  
  writeStream.close();
  unloadMutex.unlock();
  
}

Chunk* ChunkManager::LoadChunk(int chunkX, int chunkY, int chunkZ)
{

  return nullptr;
}