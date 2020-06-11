<<<<<<< HEAD
#ifndef _FIXEDALLOCATOR_H_
#define _FIXEDALLOCATOR_H_
=======
>>>>>>> 2b807ad90ddf1ca0fb7069dd79916b5028e8d0f5
#include "Chunk.h"
#include <vector>
class FixedAllocator
{
<<<<<<< HEAD
    public:
        void* Allocate();
    private:
        std::size_t blockSize_;
        unsigned char numBlocks_;
        typedef std::vector<Chunk> Chunks;
        Chunks chunks_;
        Chunk* allockChunk_;
        Chunk* deallocChunk_;
};
#endif
=======
public:
    void* Allocate();

private:
    std::size_t blockSize_;
    unsigned char numBlocks_;
    typedef std::vector<Chunk> Chunks;
    Chunks chunks_;
    Chunk* allocChunk_;
    Chunk* deallocChunk_;
};
>>>>>>> 2b807ad90ddf1ca0fb7069dd79916b5028e8d0f5
