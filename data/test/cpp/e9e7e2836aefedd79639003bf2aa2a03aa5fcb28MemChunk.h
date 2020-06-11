#pragma once
#include <Independent/Platform/PreCompileHeader.h>
#include <Core/Memory/MemStack.h>
class MemChunk
{
public:
	struct MemChunkNode
	{
		void* Chunk;
		MemChunkNode* Next;
		size_t ChunkSize;
		size_t NumBlock;
	};
	MemChunk();
	MemChunk(size_t a_ChunkSize, size_t a_BlockSize);
	~MemChunk();

	void* Alloc();
	bool Dealloc(void* ptr);
	void Initialize(size_t a_ChunkSize, size_t a_BlockSize);
private:
	void Expand(size_t a_ChunkSize);
private:
	MemChunkNode* m_pHead;
	MemChunkNode* m_pCurrentNode;
	MemChunkNode* m_pLastNode;
	MemStack m_Recyle;
	size_t m_TotalChunkSize;
	size_t m_BlockSize;
	size_t m_NumBlocks;
	size_t m_Cursor;
};

