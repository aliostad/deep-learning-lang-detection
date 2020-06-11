#include "world.hpp"

World::World() {
    chunks.push_back(new Chunk(0,0,0,0));
    chunks.push_back(new Chunk(1,0,0,1));
    chunks.push_back(new Chunk(0,1,0,1));
    chunks.push_back(new Chunk(0,0,1,1));
    chunks.push_back(new Chunk(-1,0,0,1));
    chunks.push_back(new Chunk(0,-1,0,1));
    chunks.push_back(new Chunk(0,0,-1,1));
    chunks.push_back(new Chunk(2,0,0,2));
    chunks.push_back(new Chunk(1,1,0,2));
    chunks.push_back(new Chunk(0,2,0,2));
    chunks.push_back(new Chunk(-1,2,0,2));
    chunks.push_back(new Chunk(-2,2,0,2));
    chunks.push_back(new Chunk(-2,1,0,2));
    chunks.push_back(new Chunk(-2,0,0,2));
    chunks.push_back(new Chunk(-1,-1,0,2));
    chunks.push_back(new Chunk(0,-2,0,2));
    chunks.push_back(new Chunk(1,-2,0,2));
    chunks.push_back(new Chunk(2,-2,0,2));
    chunks.push_back(new Chunk(2,-1,0,2));
}

World::~World() {
    for (Chunk *chunk : chunks) {
        delete chunk;
    }
    chunks.clear();
}
