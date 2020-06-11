#include "chunk.hpp"

#include <iostream>

#include <cstdlib>
#include <cmath>

Chunk::Chunk(int i, int j, int k, int y) 
        : i(i), j(j), k(k), y(y) {
    blocks = new Block[(1 + 3*CHUNK_SIZE*(CHUNK_SIZE+1))*CHUNK_HEIGHT];
    this->begin().set_indices_till(this->end());
    for (Block &block : (*this)) {
        block.type = (i+2*j+3*k+4*y)%4+1;
    }
}

Chunk::~Chunk() {
    delete[] blocks;
}

Chunk::iterator Chunk::begin() {
    return Chunk::iterator(this);
}

Chunk::iterator Chunk::end() {
    return Chunk::iterator(this, 0);
}
