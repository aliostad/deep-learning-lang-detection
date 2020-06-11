#include "blocksegregator.h"
#include <cassert>
#include "exception.h"

namespace g2
	{
	//-----------------------------------------------------------------------------------------//
	BlockSegregator::BlockSegregator( size_t chunkSize )
		:head_( NULL ),
		 chunkSize_( chunkSize )
		{
		assert( chunkSize != 0 );
		}

	//-----------------------------------------------------------------------------------------//
	BlockSegregator::~BlockSegregator()
		{
		}

	//-----------------------------------------------------------------------------------------//
	void BlockSegregator::AddBlock( void *block, size_t size )
		{
		if( size < chunkSize_ )
			{
			return;
			}
		
		uint8_t *tmp = (uint8_t*)block;
		size_t count = ( size / chunkSize_ ) - 1;
		
		for( size_t i = 0; i < count; ++i )
			{
			SetNext( tmp, tmp + chunkSize_ );
			tmp += chunkSize_;
			}
		
		// if "block" is the initial block,
		// the "chunk_t.next" value of "tmp" which points to end of "block" will be NULL. (described as A)
		// otherwise, "chunk_t.next" value of "tmp" will be old head of block. (described as B)
		//
		// A.
		// |--block--------------------------------------|
		// |[chunk_t.next]->[chunk_t.next]->[chunk_t.next]->NULL|
		// ^->head_
		//
		// B.
		// _1. before updating linked list.
		// |--old block----------------------------------|
		// |[chunk_t.next]->[chunk_t.next]->[chunk_t.next]->NULL|
		// ^->head_
		// ^-------------------------------------------------
		//                                                  |
		// _2. after updating linked list.                  |
		// |--new block----------------------------------|  |--old block----------------------------------|
		// |[chunk_t.next]->[chunk_t.next]->[chunk_t.next]->|[chunk_t.next]->[chunk_t.next]->[chunk_t.next]->NULL|
		// ^->head_                                         ^-old head_
		//
		
		SetNext( tmp, head_ );
		head_ = (chunk_t*)block;
		}
	}
