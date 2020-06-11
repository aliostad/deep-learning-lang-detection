#include "xtal.h"
#include "xtal_setting.h"
#include "xtal_utility.h"
#include "xtal_allocator.h"

#include <cstring>

namespace xtal{

void expand_simple_dynamic_pointer_array(void* abegin, void* aend, void* acurrent, int addsize){
	void*** begin = (void***)abegin;
	void*** end = (void***)aend;
	void*** current = (void***)acurrent;

	uint_t size = (uint_t)(*end-*begin);
	uint_t newsize = size+addsize;
	void** newbegin=(void**)xmalloc(sizeof(void*)*newsize);
	std::memcpy(newbegin, *begin, sizeof(void*)*size);
	*end = newbegin+newsize;
	*current = newbegin+(*current-*begin);
	xfree(*begin, sizeof(void*)*size);
	*begin = newbegin;	
}

void fit_simple_dynamic_pointer_array(void* abegin, void* aend, void* acurrent){
	void*** begin = (void***)abegin;
	void*** end = (void***)aend;
	void*** current = (void***)acurrent;

	uint_t size = (uint_t)(*end-*begin);
	uint_t newsize = (uint_t)(*current-*begin);
	if(newsize){
		void** newbegin=(void**)xmalloc(sizeof(void*)*newsize);
		std::memcpy(newbegin, *begin, sizeof(void*)*newsize);
		*end = newbegin+newsize;
		*current = newbegin+newsize;
		xfree(*begin, sizeof(void*)*size);
		*begin = newbegin;	
	}
	else{
		xfree(*begin, sizeof(void*)*size);
		*begin = *end = *current = 0;
	}
}

///////////////////////////////////////

#ifndef XTAL_NO_SMALL_ALLOCATOR

MemoryPool::MemoryPool(){
	free_chunk_ = 0;
	full_chunk_ = 0;
}

void* MemoryPool::malloc(Chunk** out){
	Chunk* chunk = free_chunk_;
	if(chunk){
		void* ret = chunk->free_data;
		chunk->free_data = static_cast<data_t*>(*chunk->free_data);
		XTAL_ASSERT(chunk->count>0);
		chunk->count--;
		if(chunk->count==0){
			// free chunk listからはずす
			if(chunk->next){
				chunk->next->prev = 0;
			}
			free_chunk_ = chunk->next;

			// full chunk listにつなぐ
			chunk->prev = 0;
			chunk->next = full_chunk_;
			if(full_chunk_){
				full_chunk_->prev = chunk;
			}
			full_chunk_ = chunk;
		}
		*out = chunk;
		return ret;
	}

	add_chunk();
	return malloc(out);
}

void MemoryPool::free(void* mem, Chunk* chunk){
	*static_cast<data_t*>(mem) = chunk->free_data;
	chunk->free_data = static_cast<data_t*>(mem);

	if(chunk->count==0){
		// full chunk listからはずす
		if(chunk->next){
			chunk->next->prev = chunk->prev;
		}

		if(chunk->prev){
			chunk->prev->next = chunk->next;
		}
		else{
			full_chunk_ = chunk->next;
		}

		// free chunk listにつなぐ
		chunk->prev = 0;
		chunk->next = free_chunk_;
		if(free_chunk_){
			free_chunk_->prev = chunk;
		}
		free_chunk_ = chunk;

		chunk->count = 1;
	}
	else if(chunk->count==BLOCK_COUNT-1){
		// free chunk listからはずす
		if(chunk->next){
			chunk->next->prev = chunk->prev;
		}

		if(chunk->prev){
			chunk->prev->next = chunk->next;
		}
		else{
			free_chunk_ = chunk->next;
		}

		xfree_align(chunk->buf(), BLOCK_MEMORY_SIZE + sizeof(Chunk), BLOCK_SIZE);
	}
	else{
		chunk->count++;
	}
}

void MemoryPool::add_chunk(){
	u8* memory = (u8*)xmalloc_align(BLOCK_MEMORY_SIZE + sizeof(Chunk), BLOCK_SIZE);
	Chunk* chunk = (Chunk*)(memory + BLOCK_MEMORY_SIZE);
	
	chunk->next = 0;
	data_t* p = chunk->buf();
	for(uint_t i=0; i<BLOCK_COUNT-1; ++i){
		data_t* next_block = (data_t*)((u8*)p+BLOCK_SIZE);
		*p = next_block;
		p = next_block;
	}
	*p = 0;
	chunk->free_data = chunk->buf();
	chunk->count = BLOCK_COUNT;

	chunk->prev = 0;
	chunk->next = free_chunk_;
	if(free_chunk_){
		free_chunk_->prev = chunk;
	}
	free_chunk_ = chunk;
}

void MemoryPool::release(){
	for(Chunk* p=free_chunk_; p; ){
		Chunk* next = p->next;
		xfree_align(p->buf(), BLOCK_MEMORY_SIZE + sizeof(Chunk), BLOCK_SIZE);
		p = next;
	}
	
	for(Chunk* p=full_chunk_; p; ){
		Chunk* next = p->next;
		xfree_align(p->buf(), BLOCK_MEMORY_SIZE + sizeof(Chunk), BLOCK_SIZE);
		p = next;
	}

	full_chunk_ = 0;
	free_chunk_ = 0;
}


FixedAllocator::FixedAllocator(){
	free_chunk_ = 0;
	full_chunk_ = 0;
}

void FixedAllocator::init(MemoryPool* pool, uint_t block_size, uint_t block_count){
	pool_ = pool;
	block_size_ = block_size;
	block_count_ = block_count;
	XTAL_ASSERT(block_count_>1);
}

void* FixedAllocator::malloc(){
	Chunk* chunk = free_chunk_;
	if(chunk){
		void* ret = chunk->free_data;
		chunk->free_data = static_cast<data_t*>(*chunk->free_data);
		XTAL_ASSERT(chunk->count>0);
		chunk->count--;
		if(chunk->count==0){
			// free chunk listからはずす
			if(chunk->next){
				chunk->next->prev = 0;
			}
			free_chunk_ = chunk->next;

			// full chunk listにつなぐ
			chunk->prev = 0;
			chunk->next = full_chunk_;
			if(full_chunk_){
				full_chunk_->prev = chunk;
			}
			full_chunk_ = chunk;
		}
		return ret;
	}

	add_chunk();
	return malloc();
}

void FixedAllocator::free(void* mem){
	Chunk* chunk = to_chunk(mem);
	*static_cast<data_t*>(mem) = chunk->free_data;
	chunk->free_data = static_cast<data_t*>(mem);

	if(chunk->count==0){
		// full chunk listからはずす
		if(chunk->next){
			chunk->next->prev = chunk->prev;
		}

		if(chunk->prev){
			chunk->prev->next = chunk->next;
		}
		else{
			full_chunk_ = chunk->next;
		}

		// free chunk listにつなぐ
		chunk->prev = 0;
		chunk->next = free_chunk_;
		if(free_chunk_){
			free_chunk_->prev = chunk;
		}
		free_chunk_ = chunk;

		chunk->count = 1;
	}
	else if(chunk->count==block_count_-1){
		// free chunk listからはずす
		if(chunk->next){
			chunk->next->prev = chunk->prev;
		}

		if(chunk->prev){
			chunk->prev->next = chunk->next;
		}
		else{
			free_chunk_ = chunk->next;
		}

		pool_->free(chunk, chunk->parent);
	}
	else{
		chunk->count++;
	}
}

void FixedAllocator::add_chunk(){
	uint_t block_count = block_count_;
	uint_t block_size = block_size_*ONE_SIZE;
	MemoryPool::Chunk* parent;
	Chunk* chunk = (Chunk*)pool_->malloc(&parent);
	XTAL_ASSERT(chunk==align_p(chunk, MemoryPool::BLOCK_SIZE));
	
	chunk->parent = parent;
	chunk->next = 0;
	data_t* p = chunk->buf();
	for(uint_t i=0; i<block_count-1; ++i){
		data_t* next_block = (data_t*)((u8*)p+block_size);
		*p = next_block;
		p = next_block;
	}
	*p = 0;
	chunk->free_data = chunk->buf();
	chunk->count = block_count;

	chunk->prev = 0;
	chunk->next = free_chunk_;
	if(free_chunk_){
		free_chunk_->prev = chunk;
	}
	free_chunk_ = chunk;
}

void FixedAllocator::release(){
	for(Chunk* p=free_chunk_; p; ){
		Chunk* next = p->next;
		pool_->free(p, p->parent);
		p = next;
	}
	
	for(Chunk* p=full_chunk_; p; ){
		Chunk* next = p->next;
		pool_->free(p, p->parent);
		p = next;
	}

	full_chunk_ = 0;
	free_chunk_ = 0;
}

SmallObjectAllocator::SmallObjectAllocator(){
	for(int i=0; i<POOL_SIZE; ++i){
		pool_[i].init(&mpool_, i, (MemoryPool::BLOCK_SIZE-sizeof(FixedAllocator::Chunk))/((i==0 ? 1 : i)*ONE_SIZE));
	}
}

void SmallObjectAllocator::release(){
	for(int i=0; i<POOL_SIZE; ++i){
		pool_[i].release();
	}	
	mpool_.release();
}

#endif

}


