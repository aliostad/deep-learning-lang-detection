#ifndef SFML2_SHARED_CHUNK_H_
#define SFML2_SHARED_CHUNK_H_

#include "multivector.h"

class Chunk {
public:
  Chunk(int id, int size);
  Chunk(int id, int size, std::vector<int> tiles);
  ~Chunk() {}
  int id() const { return chunk_id_; }
  void AddTile(int tile_id);
  int GetTile(int tile_id);
  int size() const { return tiles_.size(); }
  bool operator==(const Chunk& other);
  bool operator!=(const Chunk& other);

private:
  MultiVector<int> tiles_;
  int size_;
  int chunk_id_;
};

#endif  // SFML2_SHARED_CHUNK_H_