#include "../Include/impl/stdafx.h"
#include "../Include/impl/allocator.h"
#include "../Include/impl/queue.h"


void *chain_allocator::allocate(size_t n)
	{
        if (n > m_block_size) 
		{
			return NULL;
		}
		int offset = align_offset(m_pcurrent_chunk->m_block_pointer);
		if (m_pcurrent_chunk->m_block_pointer + n+offset > m_block_size) 
		{
			InterlockedExchange(&m_pcurrent_chunk->m_block_pointer,0);
			claim_block();
			
		}
		offset = align_offset(m_pcurrent_chunk->m_block_pointer);
		char * ptr = & m_pcurrent_chunk->m_pblock[ m_pcurrent_chunk->m_block_pointer+ offset];
		InterlockedExchange(&m_pcurrent_chunk->m_block_pointer,m_pcurrent_chunk->m_block_pointer + offset+n);
		m_pcurrent_chunk->Increase();
        return ptr;
	}

	void chain_allocator::claim_block()
		{
//		assert(m_max_block < 20 );
		//chunk *pchunk;
		int i=0;
		std::vector<chunk*>::iterator it = m_free_chunks.begin(); 
		while (it != m_free_chunks.end() ) 
		{
			chunk* pChunk = *it;
			if (!InterlockedCompareExchange( &(pChunk->m_counter), 0 , 0 ))
			{
				m_free_chunks.erase(it);
				m_free_chunks.push_back(m_pcurrent_chunk);
				m_pcurrent_chunk = pChunk;
				return;
			}
			it++;
			
		}
		/*while (m_free_chunks.dequeue(pchunk) && i < m_max_block)
		{
			i++;
			chunk& the_chunk  = *pchunk;
			volatile long val;
			
			InterlockedExchange(&val, the_chunk.m_counter);
			//InterlockedExchange(&ptr, the_chunk.m_block_pointer);
			// chunk is properly released
			if (!val )
			{
				m_free_chunks.enqueue(m_pcurrent_chunk);
				m_pcurrent_chunk = pchunk;
				return;
			}
			else
			{
				// put it back into queue
				m_free_chunks.enqueue(pchunk);
			}
		}*/
		if (m_pcurrent_chunk) 
			m_free_chunks.push_back(m_pcurrent_chunk);

		{
			m_max_block ++;
			m_pcurrent_chunk = new chunk();
			chunk& c = *m_pcurrent_chunk;
			c.m_pblock =  (char*)malloc(m_block_size);
			c.m_block_pointer= 0;
			c.m_counter = 0;
		}
	}
