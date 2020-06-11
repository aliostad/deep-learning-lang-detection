//
// Created by mactavish on 15-4-16.
//

#include <stdint-gcc.h>
#include "mempool.h"

namespace verihy {

void* mem_list::get() {
    mem_chunk *chunk = nullptr;
    if (available){
        chunk = available;
        if (available->next){
            available->next->prev = nullptr;
        }
        available = available->next;

    } else{
        chunk = reinterpret_cast<mem_chunk*>(new unsigned char[size + extra_size]);
        chunk->size = size;
    }

    if (used){
        used->prev = chunk;
    }

    chunk->next = used;
    chunk->prev = nullptr;
    used = chunk;

    return chunk + sizeof(chunk);
}

void mem_list::put(mem_chunk *chunk) {
    if (chunk){
        auto prev = chunk->prev;
        auto nxt = chunk->next;

        if (nxt){
            nxt->prev = chunk->prev;
        }

        if (prev){
            prev->next = chunk->next;
        } else {
            used = chunk->next;
        }

        if (available){
            available->prev = chunk;
        }
        chunk->next = available;
        available = chunk;
    }
}

void mem_list::free_chunklist(mem_chunk *chunk) {
    while (chunk){
        auto tmp = chunk->next;
        delete[] chunk;
        chunk = tmp;
    }
}

mem_list::~mem_list(){
    free_chunklist(available);
    free_chunklist(used);
}

mem_pool::~mem_pool() {
    for (auto ml = mlist; ml; ){
        auto tmp = ml->next;
        delete ml;
        ml = tmp;
    }
}


void* mem_pool::alloc(uint32_t size) {
    auto ml = mlist;
    for ( ; ml && ml->size != size; ml = ml->next);
    if (!ml){
        ml = new mem_list(size);
    }
    return ml->get();
}

void mem_pool::dealloc(void *addr) {
    auto chunk = reinterpret_cast<mem_chunk*>(addr);
    chunk -= 2;

    for (auto ml = mlist; ml; ml = ml->next){
        if (ml->size == chunk->size){
            ml->put(chunk);
            break;
        }
    }
}



} // namespace verihy

