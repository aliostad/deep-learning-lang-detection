/*
 * chunk.c
 *  Created on: 2012-12-25
 *      Author: qianqians
 * chunk 
 */
#include "chunk.h"
#ifdef _WIN32
#include <Windows.h>
#endif //_WIN32

struct chunk * _create_chunk(size_t size){
	size = (size + 4095)/4096*4096;
#ifdef _WIN32
	struct chunk * _chunk = (struct chunk*)VirtualAlloc(0, size, MEM_COMMIT|MEM_RESERVE, PAGE_READWRITE);
#endif //_WIN32
	_chunk->count.store(0);
	_chunk->size = size;
	_chunk->flag = _flag;
	_chunk->rec_count = 0;
	_chunk->slide = sizeof(struct chunk);

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

bool _isfree(struct chunk * _chunk){
	return (_chunk->count.load() == 0);
}

bool _isoldchunk(struct chunk * _chunk){
	return (_chunk->rec_count > 3);
}

void * _malloc(struct chunk * _chunk, size_t size){
	void * ret = 0;

	size_t newsize = sizeof(struct chunk*) + sizeof(size_t) + size;
	struct chunk ** tmp = (struct chunk **)_brk(_chunk, newsize);
	if (tmp != 0){
		*tmp = _chunk;
		size_t * _size = (size_t*)++tmp;
		*_size = size;
		ret = (void*)++_size;
		_chunk->count++;
	}

	return ret;
}

void * _realloc(void * mem, size_t size){
	void * ret = 0;

	struct chunk * _chunk = (struct chunk *)((char*)mem - sizeof(size_t) - sizeof(struct chunk));
	if (_chunk->flag != _flag){
		abort();
	}

	size_t oldsize = *(size_t *)((char*)mem - sizeof(size_t));
	if (oldsize >= size){
		return mem;
	}

	size_t increment = size - oldsize;
	if (increment < (_chunk->size - _chunk->slide)){
		_brk(_chunk, increment);
		ret = mem;
	}

	return ret;
}

void _free(void * mem){
	struct chunk * _chunk = *(struct chunk **)((char*)mem - sizeof(size_t) - sizeof(struct chunk *));
	if (_chunk->flag != _flag){
		abort();
	}
	_chunk->count--;
}