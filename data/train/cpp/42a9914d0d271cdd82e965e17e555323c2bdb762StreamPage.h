#pragma once
#include "../../Common/stdafx.h"
#include "../../Internal/Buffer/BufferConstraint.h"
#include "../../Internal/Element/Element.h"
#include "../../Internal/Memory/MemoryManager.h"
#include "../../Internal/Buffer/BufferConstraint.h"
/* a StreamPage is a part of continuous memory
this page is get from the buffer manager
one page is divided into chunks
all chunks are connected by pointers 
pointer is saved at the chunk header inside each chunk

each chunk contains two parts: 
(1)the first is "chunk header", save the position of the next chunk
(2)the second is the remaining part of the chunk, save any information
*/
class StreamPage
{
private:
	char* buffer;

public:
	StreamPage(void)
	{
		this->buffer = MemoryManager::getInstance()->getOnePage();


	}
	~StreamPage(void){}
	inline void setPointerOfNextChunk(CHUNK_INDEX_TYPE chunk, MemoryPosition& memoryPosition)
	{
		char* buffer = this->buffer;
		int p = 0;
		*(PAGE_INDEX_TYPE*)(buffer + chunk* CHUNK_SIZE + p) = memoryPosition.pageIndex;

		//memcpy(buffer + chunk* CHUNK_SIZE + p, &memoryPosition.pageIndex, sizeof(PAGE_INDEX_TYPE));
		p += sizeof(memoryPosition.pageIndex);

		*(PAGE_INDEX_TYPE*)(buffer + chunk* CHUNK_SIZE + p) = memoryPosition.chunkIndex;
		//memcpy(buffer+ chunk* CHUNK_SIZE + p, &memoryPosition.chunkIndex, sizeof(CHUNK_INDEX_TYPE));

	}
	inline void getPointerOfNextChunk(CHUNK_INDEX_TYPE chunk, MemoryPosition& memoryPosition)
	{
		char* buffer = this->buffer;
		int p = 0;

		memoryPosition.pageIndex = *(PAGE_INDEX_TYPE*)(buffer + chunk* CHUNK_SIZE + p);
		p += sizeof(PAGE_INDEX_TYPE);
		memoryPosition.chunkIndex = *(CHUNK_INDEX_TYPE*)(buffer + chunk* CHUNK_SIZE + p);
	}
	inline void setValue( CHUNK_INDEX_TYPE chunkIndex,Element& element)
	{
		assert(element.getSize()<=CHUNK_SIZE);
		assert(chunkIndex<=CHUNK_NUMBER_ONE_PAGE);
		char* chunkPostion = this->buffer + chunkIndex*CHUNK_SIZE;
		int p= sizeof(CHUNK_INDEX_TYPE)+sizeof(PAGE_INDEX_TYPE);
		*(Timestamp*)(chunkPostion + p) = element.timestamp;
		//memcpy(chunkPostion + p , &element.timestamp,TIMESTAMP_SIZE);
		p += TIMESTAMP_SIZE;
		//memcpy(chunkPostion + p, &element.id, DOCUMENT_IDENTIFIER_SIZE);
		*(DocumentId*)(chunkPostion + p) = element.id;
		p += DOCUMENT_IDENTIFIER_SIZE;
		//memcpy(chunkPostion + p, &element.mark, MARK_SIZE);
		*(Mark*)(chunkPostion + p) = element.mark;
		p += MARK_SIZE;

		*(MasterTag*)(chunkPostion + p) = element.masterTag;
		p += MASTER_TAG_SIZE;

		memcpy(chunkPostion + p, element.document.objdata(),element.document.objsize());


	}
	inline void getValue( CHUNK_INDEX_TYPE chunkIndex,Element& element )
	{
		assert(chunkIndex<=CHUNK_NUMBER_ONE_PAGE);
		char* chunkPostion = this->buffer + chunkIndex*CHUNK_SIZE;
		int p= sizeof(CHUNK_INDEX_TYPE)+sizeof(PAGE_INDEX_TYPE);
		element.timestamp = *(Timestamp*)(chunkPostion+p);
		p += TIMESTAMP_SIZE;
		element.id = *(DocumentId*)(chunkPostion+p);
		p += DOCUMENT_IDENTIFIER_SIZE;
		element.mark = *(Mark*) (chunkPostion+p);
		p += MARK_SIZE;
		element.masterTag = *(MasterTag*)(chunkPostion+p);
		p += MASTER_TAG_SIZE;
		element.document = Document(chunkPostion+p);

	}
};

