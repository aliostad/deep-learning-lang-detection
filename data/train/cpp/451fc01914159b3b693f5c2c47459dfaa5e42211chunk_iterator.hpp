#pragma once

#include "block.hpp"

class Chunk;

class ChunkIterator {
    public:
        ChunkIterator(Chunk *);
        ChunkIterator(Chunk *, int);

        bool operator== (const ChunkIterator &);
        bool operator!= (const ChunkIterator &);

        ChunkIterator & operator++ ();
        ChunkIterator & operator++ (int);
        Block & operator* ();

        void set_indices_till(const ChunkIterator &);

    private:
        Chunk *chunk;

        int index();

        int i, j, k, y, n, side, l;
};

#include "chunk.hpp"
