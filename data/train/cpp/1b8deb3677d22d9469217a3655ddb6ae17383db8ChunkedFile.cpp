#include "ChunkedFile.hpp"

#include <cassert>

using std::ifstream;
using std::string;
using std::uint64_t;
using std::uint8_t;


ChunkedFile::ChunkedFile(const string& rootDirectory,
                         uint64_t chunkSize)
  : chunkSize(chunkSize)
{
  (void) rootDirectory;
}

void
ChunkedFile::ComputeChunkId(std::uint64_t byteOffset, size_t& chunkId) const
{
  chunkId = byteOffset % chunkSize;
}

void
ChunkedFile::ComputeChunkIdAndRemainder(
    uint64_t byteOffset, size_t& chunkId, uint64_t& remainder) const
{
  ComputeChunkId(byteOffset, chunkId);
  remainder = byteOffset - (chunkId * chunkSize);
  assert(remainder < chunkSize);
}
/*
ssize_t
ChunkedFile::ReadBytes(uint64_t offset, uint8_t* bytes, size_t byteCount)
{
  size_t chunkId;
  uint64_t remainder;
  ComputeChunkIdAndRemainder(offset, chunkId, remainder);

  // Chunk id is out of current bounds
  if (chunkId > fileChunks.size()) {
    return 0;
  }

  // Chunk is entirely sparse.
  if (!fileChunks[chunkSize].is_open()) {
    return 0;
  }
}*/
