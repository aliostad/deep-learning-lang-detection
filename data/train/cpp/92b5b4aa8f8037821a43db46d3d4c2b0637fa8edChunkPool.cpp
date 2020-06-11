#include "ChunkPool.hpp"

BEGIN_INANITY

ChunkPool::ChunkPool(size_t chunkSize, size_t chunksInBatchCount)
: firstFreeChunk(0)
{
	if(chunkSize < sizeof(void*))
		chunkSize = sizeof(void*);
	this->chunkSize = chunkSize;

	if(!chunksInBatchCount)
	{
		chunksInBatchCount = 0x10000 / chunkSize;
		if(!chunksInBatchCount)
			chunksInBatchCount = 1;
	}
	this->chunksInBatchCount = chunksInBatchCount;
}

void* ChunkPool::Allocate()
{
	if(!firstFreeChunk)
	{
		// allocate new batch (region)
		char* region = (char*)MemoryPool::Allocate(chunkSize * chunksInBatchCount);
		// organize new free chunks in a list
		for(size_t i = 0; i < chunksInBatchCount; ++i)
		{
			void* chunk = region + i * chunkSize;
			*(void**)chunk = firstFreeChunk;
			firstFreeChunk = chunk;
		}
	}

	// remove chunk from list
	void* chunk = firstFreeChunk;
	firstFreeChunk = *(void**)chunk;

	return chunk;
}

void ChunkPool::Free(void* chunk)
{
	// add a chunk into list of free chunks
	*(void**)chunk = firstFreeChunk;
	firstFreeChunk = chunk;
}

END_INANITY
