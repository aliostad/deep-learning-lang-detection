/*
 * mirco_mempage_heap.c
 *  Created on: 2012-12-21
 *      Author: qianqians
 * mirco_mempage_heap 
 */
#include "chunk.h"
#include "mirco_mempage_heap.h"
#include "mempage_heap.h"

size_t chunk_size = 1024*64;

bool flag(mirco_mempage_heap * _heap){
	return _heap->_flag.test_and_set();
}

void clear(mirco_mempage_heap * _heap){
	_heap->_flag.clear();
}

void * _mirco_mempage_heap_alloc_big(struct mirco_mempage_heap * _heap, size_t size){
	void * ret = _malloc(_heap->chunk, size);
	if (ret == 0){	
		size_t _chunksize = ((size+sizeof(struct chunk)+sizeof(struct chunk*)+sizeof(size_t))*2+chunk_size-1)/chunk_size*chunk_size;
		size_t _old_chunksize = _heap->chunk->size;

		if (_chunksize <= _old_chunksize){
			do{
				if (_heap->chunk->count.load() == 0){
					_heap->chunk->slide = sizeof(struct chunk);
					break;
				}else{
					_heap->chunk->rec_flag.store(1);
					char flag = 1;
					if (_heap->chunk->count.load() == 0){
						if (_heap->chunk->rec_flag.compare_exchange_weak(flag, 0)){
							_heap->chunk->slide = sizeof(struct chunk);
							break;
						}
					}
				}
				_heap->chunk = _chunk(_heap->_father_heap, _old_chunksize);
			}while(0);
		}else{
			if (_heap->chunk->count.load() == 0){
				_recover_chunk(_heap->_father_heap, _heap->chunk);
			}else{
				_heap->chunk->rec_flag.store(1);
				char flag = 1;
				if (_heap->chunk->count.load() == 0){
					if (_heap->chunk->rec_flag.compare_exchange_weak(flag, 2)){
						_recover_chunk(_heap->_father_heap, _heap->chunk);
					}
				}
			}
			_heap->chunk = _chunk(_heap->_father_heap, _chunksize);
		}
		ret = _malloc(_heap->chunk, size);
	}

	return ret;
}

void * _mirco_mempage_heap_alloc_small(struct mirco_mempage_heap * _heap, size_t size){
	void * ret = _malloc(_heap->chunk_small, size);
	if (ret == 0){	
		do{
			if (_heap->chunk_small->count.load() != 0){
				_heap->chunk_small->rec_flag.store(1);
				if (_heap->chunk_small->count.load() == 0){
					char flag = 1;
					if (!_heap->chunk_small->rec_flag.compare_exchange_weak(flag, 0)){
						_heap->chunk_small = _chunk(_heap->_father_heap, chunk_size);
						break;
					}
				}else{
					_heap->chunk_small = _chunk(_heap->_father_heap, chunk_size);
					break;
				}
			}
			_heap->chunk_small->slide = sizeof(struct chunk);
		}while(0);
		ret = _malloc(_heap->chunk_small, size);
	}

	return ret;
}

void * _mirco_mempage_heap_alloc(struct mirco_mempage_heap * _heap, size_t size){
	void * ret = 0;

	if (size >= 4096){
		ret = _mirco_mempage_heap_alloc_big(_heap, size);
	}else{
		ret = _mirco_mempage_heap_alloc_small(_heap, size);
	}

	return ret;
}