#include "chunk.h"

std::vector<Chunk*> Chunk::chunks;

unsigned int Chunk::next_chunk = CHUNK_ALLOC_SIZE;
unsigned int Chunk::allocated = 0;

Chunk::Chunk(World *world, signed int x, signed int y)
    : x(x)
    , y(y)
{
    world->initialize_chunk(this);
}

Chunk *Chunk::neighbor(World *world, Direction i)
{
    if (neighbors[i]) {return neighbors[i];}

    // Calculate target cx and cy.
    signed int tcx = x;
    signed int tcy = y;
    switch (i)
    {
    case up:
        tcy -= CHUNK_SIZE; break;
    case down:
        tcy += CHUNK_SIZE; break;
    case left:
        tcx -= CHUNK_SIZE; break;
    case right:
        tcx += CHUNK_SIZE; break;
    }

    // Try to find a chunk that matches the target cx and cy. If found, set neighbors and return.
    Chunk *chunk = find_chunk(tcx, tcy);

    if (chunk)
    {
        chunk->neighbors[i ^ 1] = this;
    }
    else
    {
        // If there are no chunks at the target cx and cy, make one.
        chunk = new Chunk(world, tcx, tcy);
        chunk->neighbors[i ^ 0] = 0;
        chunk->neighbors[i ^ 1] = this;
        chunk->neighbors[i ^ 2] = 0;
        chunk->neighbors[i ^ 3] = 0;
    }

    neighbors[i] = chunk;

    return chunk;
}

Chunk *Chunk::find_chunk(signed int tx, signed int ty)
{
    // Loop through each chunk.
    // TODO: Reverse iterating (might be faster because newer chunks are more likely to be closer).
    // TODO: Intelligent pathfinding algorithm
    std::vector<Chunk*>::iterator ci = chunks.begin();
    while (ci != chunks.end())
    {
        Chunk *chunk = *ci;
        ci++;
        Chunk *chunk_e = chunk + (ci != chunks.end() ? CHUNK_ALLOC_SIZE : next_chunk);
        while (chunk < chunk_e)
        {
            if (chunk->x == tx && chunk->y == ty)
            {
                return chunk;
            }
            chunk++;
        }
    }

    return 0;
}

void Chunk::set_pixel(signed int px, signed int py)
{
}
