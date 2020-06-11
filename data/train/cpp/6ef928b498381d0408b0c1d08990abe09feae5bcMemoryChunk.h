/*
 * @file	MemoryChunk.h
 * @author	LKF
 * @date	2014-11-5  17:51
 * @brief	
 * @Copyright (C) 2014, by Bning
 */
#ifndef __MemoryChunk_H__
#define __MemoryChunk_H__
#include "_osdef.h"
class MemoryChunk
{
public:
	MemoryChunk(const size_t& size);
	~MemoryChunk(void);

	inline void* GetMemoryHead(){return m_pointer;}
	inline int GetMemorySize(){return m_size;}

private:
	DISALLOW_COPY_AND_ASSIGN(MemoryChunk);

private:
	void* m_pointer;
	size_t m_size;
	size_t m_offset;
};

typedef std::tr1::shared_ptr<MemoryChunk> MemoryChunkPtr;


#endif // MemoryChunk_H__

