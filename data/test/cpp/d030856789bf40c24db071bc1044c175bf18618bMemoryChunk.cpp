//
// Created by mrozolga on 28.03.17.
//

#include "MemoryChunk.h"

namespace memorychunk {
    MemoryChunk::MemoryChunk(size_t sz) {

        ptr = new int8_t[sz];
        this->sz = sz;
    }

    int8_t *MemoryChunk::MemoryAt(size_t offset) const {
        return (ptr + offset);
    }

    size_t MemoryChunk::ChunkSize() const {
        return sz;
    }

    void MemoryChunk::Copy(const MemoryChunk &xxx) {
        ptr = new int8_t[xxx.ChunkSize()];
        std::copy(xxx.ptr, xxx.ptr + sz, ptr);
        sz = xxx.ChunkSize();
    }

    MemoryChunk::MemoryChunk(const MemoryChunk &xxx) {
        Copy(xxx);

    }


    MemoryChunk::MemoryChunk(MemoryChunk &&xxx) {
        ptr = xxx.ptr;
        sz = xxx.ChunkSize();
        xxx.ptr = nullptr;
        xxx.sz = 0;
    }

    MemoryChunk &MemoryChunk::operator=(const MemoryChunk &xxx) {
        if (this == &xxx) {
            return *this;
        }
        delete[] ptr;
        Copy(xxx);
    }

    MemoryChunk &MemoryChunk::operator=(MemoryChunk &&xxx) {
        if (this == &xxx) {
            return xxx;
        }
        delete[] ptr;
        ptr = nullptr;
        std::copy(xxx.ptr, xxx.ptr + sz, ptr);
    }

    MemoryChunk::~MemoryChunk() {
        delete ptr;
    }
}