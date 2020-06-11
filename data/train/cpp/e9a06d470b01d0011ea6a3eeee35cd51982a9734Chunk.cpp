#include <mine/Chunk.hpp>
#include <mine/Enforce.hpp>
#include <mine/Logger.hpp>

using namespace mine;

Chunk::Chunk()
{}

bool Chunk::isInMemory() const
{
  ENFORCE(m_blocks.size() == 0 || m_blocks.size() == CHUNK_SIZE * CHUNK_SIZE,
          "Size of chunk is invalid! size="<<m_blocks.size());
  return m_blocks.size() == CHUNK_SIZE * CHUNK_SIZE;
}

void Chunk::load()
{
  LOG_DEBUG("loading chunk...");
  ENFORCE(!isInMemory(), "Chunk is already in memory!");

  // at the moment "load" means a simple resize...
  m_blocks.resize(CHUNK_SIZE * CHUNK_SIZE);

  ENFORCE(isInMemory(), "Fatal error: Chunk::load() is buggy!");
}
