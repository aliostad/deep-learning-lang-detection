#include "mmem.h"
#include <exception>

ChunkAllocator::ChunkAllocator(uint64_t chunkSize, uint64_t chunkCount):
    m_ChunkCount(chunkCount), m_ChunkSize(chunkSize), m_Memory(NULL)
{
    m_Memory = VirtualAlloc(NULL, m_ChunkCount * m_ChunkSize, MEM_RESERVE, PAGE_READWRITE);
    if (!m_Memory) {
        throw std::exception("Failed to reserve memory");
    }
}

ChunkAllocator::~ChunkAllocator()
{
    VirtualFree(m_Memory, 0, MEM_RELEASE);
}

LPVOID ChunkAllocator::getChunk(uint64_t chunk)
{
    LPVOID mem = VirtualAlloc(reinterpret_cast<uint8_t*>(m_Memory) + chunk * m_ChunkSize, m_ChunkSize, MEM_COMMIT, PAGE_READWRITE);
    if (!mem) {
        throw std::exception("Failed to commit chunk");
    }
    return mem;
}
