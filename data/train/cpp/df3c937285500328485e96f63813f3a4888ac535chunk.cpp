/*
 * chunk.c
 *  Created on: 2012-12-25
 *      Author: qianqians
 * chunk 
 */
#include "chunk.h"
#include "mempage_heap.h"
#ifdef _WIN32
#include <Windows.h>
#endif //_WIN32

struct chunk * _create_chunk(struct mempage_heap * _heap, size_t size){
	size = (size + 4095)/4096*4096;
#ifdef _WIN32
	struct chunk * _chunk = (struct chunk*)VirtualAlloc(0, size, MEM_COMMIT|MEM_RESERVE, PAGE_READWRITE);
#endif //_WIN32
	if (_chunk != 0){
		_chunk->count.store(0);
		_chunk->_heap = _heap;
		_chunk->size = size;
		_chunk->flag = _flag;
		_chunk->rec_flag = 0;
		_chunk->slide = sizeof(struct chunk);
	}

	return _chunk;
}

void * _brk(struct chunk * _chunk, size_t size){
	void * ret = 0;

	if ((_chunk->slide + size) <= _chunk->size){
		ret = (void*)((char*)_chunk + _chunk->slide);
		_chunk->slide += size;
	}

	return ret;
}

struct chunk * _merge_chunk(struct chunk * _c1, struct chunk * _c2){
	struct chunk * ret = 0;
	if ((char*)_c1 == ((char*)_c2 + _c2->size)){
		ret = _c2;
		ret->size += _c1->size;
	}
	else if (((char*)_c1 + _c1->size) == (char*)_c2){
		ret = _c1;
		ret->size += _c2->size;
	}

	return ret;
}

void * _malloc(struct chunk * _chunk, size_t size){
	if (_chunk->count.load() == 0){
		_chunk->slide = sizeof(struct chunk);
	}
	
	void * ret = 0;
	_chunk->count++;

	size_t newsize = sizeof(struct chunk*) + sizeof(size_t) + size;
	if ((_chunk->slide + newsize) <= _chunk->size){
		struct chunk ** tmp = (struct chunk **)((char*)_chunk + _chunk->slide);
		_chunk->slide += newsize;
		*tmp = _chunk;
		size_t * _size = (size_t*)++tmp;
		*_size = size;
		ret = (void*)++_size;
	}

	if (ret == 0){
		_chunk->count--;
	}

	return ret;
}

void * _realloc(void * mem, size_t size){
	void * ret = 0;

	struct chunk * _chunk = *(struct chunk **)((char*)mem - sizeof(size_t) - sizeof(struct chunk*));
	if (_chunk->flag != _flag){
		abort();
	}

	size_t oldsize = *(size_t *)((char*)mem - sizeof(size_t));
	size_t slide = (char*)mem + oldsize - (char*)_chunk;

	if (oldsize >= size){
		if (slide == _chunk->slide){
			_chunk->slide -= (oldsize - size);
		}
		return mem;
	}

	if (slide == _chunk->slide){
		size_t increment = size - oldsize;
		if (increment < (_chunk->size - _chunk->slide)){
			_brk(_chunk, increment);
			ret = mem;
		}
	}

	return ret;
}

void _free(void * mem){
	struct chunk * _chunk = *(struct chunk **)((char*)mem - sizeof(size_t) - sizeof(struct chunk *));
	if (_chunk->flag != _flag){
		abort();
	}
	if (--_chunk->count == 0){
		char flag = 1;
		if (_chunk->rec_flag.compare_exchange_weak(flag, 2)){
			_recover_chunk(_chunk->_heap, _chunk);
		}
	}
}