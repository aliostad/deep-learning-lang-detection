#include "chunkmanager.h"
#include <iostream>
#include <vector>
#include <math.h>

ChunkManager::ChunkManager()
{
  chunks.resize(CMX * CMY * CMZ);
}

inline bool ChunkManager::outOfBounds(int x, int y, int z)
{
  return (0 > x || x >= CMX * Chunk::CHUNK_SIZE || 0 > y ||
          y >= CMY * Chunk::CHUNK_SIZE || 0 > z ||
          z >= CMZ * Chunk::CHUNK_SIZE);
}

BlockType ChunkManager::get(int x, int y, int z)
{
  if (outOfBounds(x, y, z))
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

void ChunkManager::set(glm::vec3 pos, BlockType type)
{
  set(int(pos.x), int(pos.y), int(pos.z), type);
}

void ChunkManager::set(int x, int y, int z, BlockType type)
{
  if (outOfBounds(x, y, z))
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
      std::make_shared<Chunk>(cmx * Chunk::CHUNK_SIZE, cmy * Chunk::CHUNK_SIZE,
                              cmz * Chunk::CHUNK_SIZE);
  }

  auto chunk = chunks[index(cmx, cmy, cmz)];

  chunk->set(x % CMX, y % CMY, z % CMZ, type);

  chunksToUpdate.insert(chunk);
}

int ChunkManager::index(int x, int y, int z)
{
  return x * CMY * CMZ + y * CMZ + z;
}

std::shared_ptr<Chunk> ChunkManager::getChunkAtIndex(int x, int y, int z)
{
  std::shared_ptr<Chunk> chunk;
  return (outOfBounds(x, y, z)
            ? chunk
            : chunks[index(x / Chunk::CHUNK_SIZE, y / Chunk::CHUNK_SIZE,
                           z / Chunk::CHUNK_SIZE)]);
}

void ChunkManager::update()
{
  for (auto& c : chunksToUpdate)
  {
    auto down = getChunkAtIndex(c->X, c->Y - Chunk::CHUNK_SIZE, c->Z);
    auto up = getChunkAtIndex(c->X, c->Y + Chunk::CHUNK_SIZE, c->Z);
    auto left = getChunkAtIndex(c->X - Chunk::CHUNK_SIZE, c->Y, c->Z);
    auto right = getChunkAtIndex(c->X + Chunk::CHUNK_SIZE, c->Y, c->Z);
    auto back = getChunkAtIndex(c->X, c->Y, c->Z - Chunk::CHUNK_SIZE);
    auto front = getChunkAtIndex(c->X, c->Y, c->Z + Chunk::CHUNK_SIZE);
    c->update(down, up, left, right, back, front);
  }

  chunksToUpdate.clear();
}

// TODO: remove drawing code from here. expose list of chunks only
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
