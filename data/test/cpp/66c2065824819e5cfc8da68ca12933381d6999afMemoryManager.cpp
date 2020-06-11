#include "MemoryManager.hpp"


MemoryManager::MemoryManager():
    m_total_chunks(0),
    m_used_chunks(0),
    m_free_chunk_list(nullptr)
{

}


MemoryManager::ptr_type MemoryManager::Alloc()
{
    if(Empty()){
        return nullptr;
    }

    ptr_type chunk = m_free_chunk_list;
    m_free_chunk_list = NextOfChunk(m_free_chunk_list);
    ++ m_used_chunks;

    return chunk;
}


void MemoryManager::Free(ptr_type chunk)
{
    NextOfChunk(chunk) = m_free_chunk_list;
    m_free_chunk_list = chunk;
    -- m_used_chunks;
}


bool MemoryManager::Alloc(ptr_type chunk_arr[], size_type length)
{
    if(FreeChunks() < length){
        return false;
    }

    for(size_type i = 0; i < length; ++i){
        chunk_arr[i] = m_free_chunk_list;
        m_free_chunk_list = NextOfChunk(m_free_chunk_list);
    }

    m_used_chunks += length;
    return true;
}


void MemoryManager::Free(ptr_type chunk_arr[], size_type length)
{
    for(size_type i = 0; i < length; ++i){
        NextOfChunk(chunk_arr[i]) = m_free_chunk_list;
        m_free_chunk_list = chunk_arr[i];
    }

    m_used_chunks -= length;
}


void MemoryManager::AddBlock(ptr_type block, size_type block_size, size_type chunk_size)
{
    size_type num_of_chunks = block_size / chunk_size;
    ptr_type chunk = block + (num_of_chunks - 1) * chunk_size;
    ptr_type tail = m_free_chunk_list;

    for( ; chunk >= block; chunk -= chunk_size){
        OnInitChunk(chunk);
        NextOfChunk(chunk) = tail;
        tail = chunk;
    }

    m_free_chunk_list = block;
    m_total_chunks += num_of_chunks;
}


void MemoryManager::ForEachChunkInBlock(ptr_type block, size_type block_size,
    size_type chunk_size, void (*func)(ptr_type chunk))
{
    ptr_type end = block + (block_size / chunk_size - 1) * chunk_size;
    for(ptr_type chunk = block; chunk <= end; chunk += chunk_size){
        func(chunk);
    };
}


MemoryManager::ptr_type &MemoryManager::NextOfChunk(ptr_type chunk)
{
    return *reinterpret_cast<ptr_type *>(chunk);
}
