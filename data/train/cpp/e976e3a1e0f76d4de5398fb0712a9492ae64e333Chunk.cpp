#include "Chunk.h"

Chunk::Chunk(glm::ivec3 pos) :
    _blocks(CHUNK_SIZE * CHUNK_SIZE * CHUNK_SIZE),
    _pos(pos)
{
    std::srand(500);
    for (BlockBase *&bl : _blocks)
    {

        bl = new BlockBase();
    }
}

Chunk::~Chunk()
{
    //dtor
}

void Chunk::genVbo()
{
    _vboBuilder.clear();
    for (int x = 0; x < CHUNK_SIZE; x++)
        for ( int y = 0; y < CHUNK_SIZE; y++)
            for ( int z = 0; z < CHUNK_SIZE; z++)
            {
                if (x == 0 || y == 0 || z == 0 || x == CHUNK_SIZE - 1 || y == CHUNK_SIZE - 1 || z == CHUNK_SIZE - 1)
                    _blocks.at(z + y * CHUNK_SIZE + x * CHUNK_SIZE * CHUNK_SIZE)->render(_pos * CHUNK_SIZE + glm::ivec3(x, y, z), &_vboBuilder, glm::vec3(1.0f, 1.0f, 1.0f));
                else
                    _blocks.at(z + y * CHUNK_SIZE + x * CHUNK_SIZE * CHUNK_SIZE)->render(_pos * CHUNK_SIZE + glm::ivec3(x, y, z), &_vboBuilder, glm::vec3(0.0f, 1.0f, 0.0f));



            }
}
