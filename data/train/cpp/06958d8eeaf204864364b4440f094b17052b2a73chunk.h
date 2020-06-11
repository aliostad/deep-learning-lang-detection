#ifndef CHUNK_H
#define CHUNK_H

#include "defs.h"
#include "gl.h"

#include "world/world.h"
#include "world/cell.h"

#include "util/direction.h"
#include "util/weakset.h"

class World;

struct Chunk
{
    Chunk() {}
    Chunk(World *world, signed int x, signed int y);

    signed int x;
    signed int y;

	/*
	float x;
	float y;
	*/

	Cell cells[CHUNK_SIZE * CHUNK_SIZE];

    WeakSet<Particle*> particles;

    GLuint tex;

    Chunk *neighbors[4];

    Chunk *neighbor(World *world, Direction i);

    Chunk *find_chunk(signed int tx, signed int ty);

    void set_pixel(signed int px, signed int py);

public:
    void *operator new(std::size_t s)
	{
		assert(s == sizeof(Chunk));

		if (next_chunk == CHUNK_ALLOC_SIZE)
		{
			chunks.push_back(new Chunk[CHUNK_ALLOC_SIZE]);
			next_chunk = 0;
		}

		allocated++;
        return chunks.back() + next_chunk++;
	}

	// Most chunks won't be de-allocated until the end of the program.
    void operator delete(void *chunk, std::size_t s)
	{
		allocated--;
		if (!allocated)
		{
			std::vector<Chunk*>::iterator i = chunks.begin();
			while (i != chunks.end())
			{
				delete[] *i;
				i++;
			}
            chunks.clear();
			next_chunk = CHUNK_ALLOC_SIZE;
		}
	}

protected:
	static std::vector<Chunk*> chunks;
    static unsigned int next_chunk;
    static unsigned int allocated;
};

#endif // CHUNK_H
