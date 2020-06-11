#include "memory_alloc.h"

void MemoryAllocator::operator () (uint32_t __heap, uint32_t __size) 
{
	MemoryChunk *chunk = (MemoryChunk *)__heap;
    /*
	for (memory_size_t i = 0; i < __size; i++) {
	    *((uint8_t *)__heap + i) = 0;
	}
    */
	chunk->size = __size - sizeof(MemoryChunk) - 4;
	this->poolFree.add(chunk);
}

    MemoryAllocator::MemoryAllocator (uint32_t __heap, uint32_t __size) 
{
	MemoryChunk *chunk = (MemoryChunk *)__heap;
	for (memory_size_t i = 0; i < __size; i++) {
	    *((uint8_t *)__heap + i) = 0;
	}
	chunk->size = __size;
	this->poolFree .add(chunk);
}

MemoryChunk *MemoryAllocator::separate (MemoryChunk *memo, memory_size_t size)
{
	MemoryChunk *chunk = (MemoryChunk *)0;
	chunk = (MemoryChunk *)((alloc_addr_t)memo + size + sizeof(MemoryChunk));
	chunk->size = memo->size - size - sizeof(MemoryChunk);
	memo->size = size;
	return chunk;
}

int32_t MemoryAllocator::sanitize (ArrayListBase <MemoryChunk> &List)
{
	if (List.size() < 2) {
		return -1;
	} else {}
	MemoryChunk *New = List.getLast()->nextLink, *Old = List.getLast();
	while (New != (MemoryChunk *)0) {
	if ((alloc_addr_t)Old + Old->size + sizeof(MemoryChunk) == (alloc_addr_t)New) {
		Old->size += sizeof(MemoryChunk) + New->size;
		List.remove(New);
        this->sanitized++;
	}
	Old = New;
	New = New->prevLink;
	}	
	New = List.getFirst()->nextLink;
	Old = List.getFirst();
	while (New != (MemoryChunk *)0) {
	if ((alloc_addr_t)Old + Old->size + sizeof(MemoryChunk) == (alloc_addr_t)New) {
        Old->size += sizeof(MemoryChunk) + New->size;
        List.remove(New);
        this->sanitized++;
	}
	Old = New;
	New = New->nextLink;
	}	
    return 0;		
}

void *MemoryAllocator::New (memory_size_t size)
{
	 if (!size) return 0;
	 size |= MemoryAlignment;
	 __align(MemoryAlignment) MemoryChunk *chunk = this->poolFree.getFirst();
			while (chunk != (MemoryChunk *)0) {
				if (chunk->size >= size) {
					this->poolFree.remove(chunk);
					if (chunk->size >= size + sizeof(MemoryChunk) + sizeof(MemoryChunk) * 2) 
						this->poolFree.add(separate(chunk, size));
					this->poolInUse.add(chunk);
                    this->Success++;
					return (void *)(chunk + 1);
				}
				chunk = chunk->nextLink;
			}
	 errno = ENOMEM;
     this->errors++;
	 return (void *)0;
}

int32_t MemoryAllocator::Delete (void *P)
{
	 if (P == (MemoryChunk *)0) {
         this->errors++;
         return errno = EINVAL;
     } else {}
	 errno = 0;
	 MemoryChunk *chunk = (MemoryChunk *)(P) - 1;
	 
	 /*
	 if (!(chunk->llink) && !(chunk->llink)) errno = EINVAL;
	 else if (!(chunk->llink)) {
		 if (chunk->rlink->llink != chunk) errno = EINVAL;
	 } else if (!(chunk->rlink)){
		 if (chunk->llink->rlink != chunk) errno = EINVAL;
	 } else {
		 if (chunk->llink->rlink != chunk->rlink->llink) errno = EINVAL;
	 }
	 */
	 if (errno == EINVAL) {
		 return errno;
	 } else {}
	 this->poolInUse.remove(chunk);
	 this->poolFree.add(chunk);
	 sanitize(this->poolFree);
	 return errno;	
}

int32_t MemoryAllocator::check ()
{
	return 0;
}

