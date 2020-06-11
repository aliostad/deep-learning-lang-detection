#include "chunk.h"

Chunk::Chunk(int id, int size) {
  chunk_id_ = id;
  size_ = size;
  tiles_ = MultiVector<int>();
}

void Chunk::AddTile(int tile_id) {
  tiles_.Add(tile_id);
}

int Chunk::GetTile(int tile_id) {
  return tiles_.GetValue(tile_id);
}

bool Chunk::operator==(const Chunk& other) {
  return id() == other.id();
}

bool Chunk::operator!=(const Chunk& other) {
  return !(*this == other);
}

Chunk::Chunk(int id, int size, std::vector<int> tiles) {
  chunk_id_ = id;
  size_ = size;
  tiles_ = MultiVector<int>(size, size, tiles);
}