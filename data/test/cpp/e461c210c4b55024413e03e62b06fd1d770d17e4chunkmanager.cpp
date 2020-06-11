#include "chunkmanager.h"
#include <iostream>
#include <vector>
#include <math.h>

ChunkManager::ChunkManager()
{
  chunks.resize(CMX * CMY * CMZ);
}

BlockType ChunkManager::get(int x, int y, int z)
{
  if (0 > x || x >= CMX * Chunk::CHUNK_SIZE || 0 > y ||
      y >= CMY * Chunk::CHUNK_SIZE || 0 > z || z >= CMZ * Chunk::CHUNK_SIZE)
  {
    // Out of bounds.
    return BlockType::Inactive;
  }
  auto cmx = x / Chunk::CHUNK_SIZE;
  auto cmy = y / Chunk::CHUNK_SIZE;
  auto cmz = z / Chunk::CHUNK_SIZE;

  x %= CMX;
  y %= CMY;
  z %= CMZ;

  if (chunks[index(cmx, cmy, cmz)] == nullptr)
  {
    // Chunk hasn't been allocated yet.
    return BlockType::Inactive;
  }

  return chunks[index(cmx, cmy, cmz)]->get(x, y, z);
}

void ChunkManager::set(int x, int y, int z, BlockType type)
{
  if (0 > x || x >= CMX * Chunk::CHUNK_SIZE || 0 > y ||
      y >= CMY * Chunk::CHUNK_SIZE || 0 > z || z >= CMZ * Chunk::CHUNK_SIZE)
  {
    return;
  }
  auto cmx = x / Chunk::CHUNK_SIZE;
  auto cmy = y / Chunk::CHUNK_SIZE;
  auto cmz = z / Chunk::CHUNK_SIZE;

  x %= CMX;
  y %= CMY;
  z %= CMZ;

  // Allocate this chunk if it doesn't exist yet.
  if (chunks[index(cmx, cmy, cmz)] == nullptr)
  {
    chunks[index(cmx, cmy, cmz)] =
      std::make_shared<Chunk>(cmx * Chunk::CHUNK_SIZE,
                              cmy * Chunk::CHUNK_SIZE,
                              cmz * Chunk::CHUNK_SIZE);
  }

  auto chunk = chunks[index(cmx, cmy, cmz)];

  // Set this Chunk's specified voxel to its new type.
  chunk->set(x % CMX, y % CMY, z % CMZ, type);

  // Schedule this chunk to be updated.
  chunksToUpdate.insert(chunk);
}

int ChunkManager::index(int x, int y, int z)
{
  return x * CMY * CMZ + y * CMZ + z;
}

void ChunkManager::update()
{
  for (auto& c : chunksToUpdate)
  {
    c->update();
  }

  chunksToUpdate.clear();
}

void ChunkManager::render(GraphicsContext& context, const glm::mat4& vp)
{
  for (auto& chunk : chunks)
  {
    if (chunk != nullptr)
    {
      auto position = chunk->getPosition();
      auto model = glm::translate(glm::mat4(1.0f), position);
      auto mvp = vp * model;
      glUniformMatrix4fv(context.mvp(), 1, GL_FALSE, &mvp[0][0]);
      chunk->render(context);
    }
  }
}
