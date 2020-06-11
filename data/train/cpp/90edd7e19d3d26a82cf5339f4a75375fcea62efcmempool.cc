#include "mempool.h"
#include <assert.h>

namespace xxbc {

MemoryPool::MemoryPool() : block_list_(NULL), free_chunk_list_(NULL) 
{
}

MemoryPool::~MemoryPool() 
{
    Block* block;
    while (block_list_) {
        block = block_list_;
        block_list_ = block_list_->next;
        free(block);
    }
}

void MemoryPool::MallocBlock() 
{
    Block* ptr = (Block*) malloc(sizeof(Block));
    assert(ptr != NULL);
    ptr->next = block_list_;
    block_list_ = ptr;

    Chunk* new_chunk = (Chunk*) ptr;
    int new_chunk_count = kBlockSize / kChunkSize;
    for (int i=0; i<new_chunk_count; ++i) {
        new_chunk->used_size = 0;
        new_chunk->free_size = kChunkSize - sizeof(Chunk);
        new_chunk->data = (char*) ptr + sizeof(Chunk);
        new_chunk->next = free_chunk_list_;
        free_chunk_list_ = new_chunk;
        new_chunk++;
    }
}

Chunk* MemoryPool::Malloc() 
{
    if (free_chunk_list_ == NULL) {
        MallocBlock();
    }

    Chunk* chunk = free_chunk_list_;
    free_chunk_list_ = free_chunk_list_->next;
    return chunk;
}

void MemoryPool::Free(Chunk* chunk) 
{
    chunk->used_size = 0;
    chunk->free_size = kChunkSize - sizeof(Chunk);
    chunk->next = free_chunk_list_;
    free_chunk_list_ = chunk;
}

int MemoryPool::BlockCount() 
{
    int count = 0;
    Block* block = block_list_;
    while (block) {
        count++;
        block = block->next;
    }
    return count;
}

int MemoryPool::FreeChunkCount() 
{
    int count = 0;
    Chunk* chunk = free_chunk_list_;
    while (chunk) {
        count++;
        chunk = chunk->next;
    }
    return count;
}

} // namespace xxbc
