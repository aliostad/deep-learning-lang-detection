
#pragma  once 

#include "FreeList.h"
#include <vector>  
#include <assert.h>
using namespace std;

#define  AALLOCSIZE			20*1024*1024		// 20M
#define  MaxALLOCSIZE	    3*AALLOCSIZE

class   SmallObjAllocator
{
public:
	SmallObjAllocator( long  chunkSize ,
					   long   MaxObjectSize)
	{
		m_blockSize = chunkSize;
		if( MaxSize < MaxObjectSize )
		{
			MaxObjectSize = MaxSize;
		}
		m_ObjSize   = MaxObjectSize;
		m_alloChunk = NULL;
	}

	~SmallObjAllocator()
	{
		std::cout << " ~SmallObjAllocator() Chunk Size =%d " << m_chunk.size() << std::endl;

		Chunks::iterator i = m_chunk.begin();

		for ( ; i != m_chunk.end(); ++i)
		{
			delete *i;
		}
		m_chunk.clear();
	}

	void*  Allocate()
	{
		/// ÄÚ´æ²»×ã
		if ( !m_alloChunk || m_alloChunk->m_availSize == 0 )
		{
			Chunks::iterator i = m_chunk.begin();
			for ( ; ; ++i)
			{
				if ( i == m_chunk.end() )
				{
					m_chunk.push_back( new Chunk(m_blockSize,m_ObjSize) );
					m_alloChunk = m_chunk.back();

					//std::cout <<" Chucks size "<< m_chunk.size() ;
					
					break;
				}
				if ( (*i)->m_availSize > 0 )
				{
					m_alloChunk = *i;
					break;
				}
			}
		}

		assert( m_alloChunk != 0 );
		assert( m_alloChunk->m_availSize != 0 );
		return m_alloChunk->Allocate();
	}
	
	bool   Destory(void* pData)
	{
		Chunks::iterator it =  m_chunk.begin();
		for( ; it != m_chunk.end() ; it++ )
		{
			if( (*it)->Check( pData ) )
			{
				(*it)->Release( pData );

				Clean();

				return true;
			}
		}
		Clean();
		return false;
	}

	void  Clean()
	{
		Chunks::iterator it =  m_chunk.begin();
		for ( ; it != m_chunk.end() ; )
		{
			if ( m_chunk.size() * AALLOCSIZE  <= MaxALLOCSIZE )
			{
				break;
			}
			if ( (*it)->Full() )
			{
				Chunk *pChunk = *it;
				delete pChunk;	pChunk= NULL;
				it = m_chunk.erase( it );
			}
			else
				it ++ ;
		}
	}

	void  Print( )
	{
		std::cout <<"block size " << m_blockSize << " chunks size "  << m_chunk.size() << std::endl;
		Chunks::iterator it =  m_chunk.begin();
		for( ; it != m_chunk.end() ; it++ )
		{
			(*it)->print();
		}
	}

private:
	typedef std::vector<Chunk*>   Chunks;
	Chunks				m_chunk;

	Chunk*				m_alloChunk;
	Chunk*				m_freeChunk;
	
	long				m_blockSize;
	long				m_ObjSize;
};