//
// Created by Rejurhf on 01.04.2017.
//

#include "MemoryChunk.h"

namespace memorychunk{
    MemoryChunk::MemoryChunk(size_t sz){
        arg_ = new int8_t[sz];
        sz_ = sz;
    }

    MemoryChunk::~MemoryChunk(){
        delete arg_;
    }

    int8_t *MemoryChunk::MemoryAt(size_t offset) const{
        if (offset < sz_)
            return &arg_[offset];
        else
            return 0;
    }

    size_t MemoryChunk::ChunkSize() const{
        return sz_;
    }

    MemoryChunk::MemoryChunk(const MemoryChunk &memo){
        sz_ = memo.ChunkSize();
        arg_ = new int8_t[sz_];
        std::copy(memo.arg_, (memo.arg_ + sz_), arg_);
    }

    MemoryChunk::MemoryChunk(MemoryChunk &&memo){
        arg_ = nullptr;
        sz_ = 0;
        std::swap(arg_, memo.arg_);
        std::swap(sz_, memo.sz_);
    }

    MemoryChunk& MemoryChunk::operator=(const MemoryChunk &memo) {
        if (this == &memo)
            return *this;
        delete arg_;
        sz_ = memo.ChunkSize();
        this->arg_ = new int8_t[sz_];
        std::copy(memo.arg_, (memo.arg_ + sz_), arg_);
    }

    MemoryChunk& MemoryChunk::operator=(MemoryChunk &&memo){
        if (this == &memo)
            return *this;
        delete arg_;
        arg_ = nullptr;
        sz_ = 0;
        std::swap(arg_, memo.arg_);
        std::swap(sz_, memo.sz_);
    }
}