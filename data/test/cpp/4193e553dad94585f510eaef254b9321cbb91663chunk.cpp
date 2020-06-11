#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <algorithm>

#include "utility.hpp"

#include "chunk.hpp"

bool LoadChunk(FILE* file, size_t size, Chunk* chunk) {
  size_t chunk_size = Chunk::chunk_size;

  if(chunk->number * chunk_size >= size) {
    memset(chunk->data, 0, chunk_size);
    return true;
  }

  size_t left_to_the_end = size - chunk->number * chunk_size;

  if(fseek(file, chunk->number * chunk_size, SEEK_SET) == -1) {
    return false;
  }

  if(fread(chunk->data, std::min(chunk_size, left_to_the_end), 1, file) != 1) {
    return false;
  }

  memset(chunk->data + std::min(chunk_size, left_to_the_end), 0, chunk_size - std::min(chunk_size, left_to_the_end));

  return true;
}

bool SaveChunk(FILE* file, size_t max_size, const Chunk* chunk) {
  size_t chunk_size = Chunk::chunk_size;

  if(fseek(file, chunk->number * chunk_size, SEEK_SET) == -1) {
    return false;
  }

  size_t left_to_the_end = max_size - chunk->number * chunk_size;

  if(fwrite(chunk->data, std::min(chunk_size, left_to_the_end), 1, file) != 1) {
    return false;
  }

  return true;
}
