#include "stream.h"
#include <memory.h>
#include <assert.h>

using namespace std;

const size_t stream_t::chunkSize = 10*1024*1024;

stream_t::stream_t(istream& i) : in(i), chunkBuffer(0), chunkRemain(0), last(0) {}

const char* stream_t::next() {
    char* p = 0;
    if (getline(in, tmp)) {
        size_t size = tmp.size();
        if (chunkRemain <= size && size < chunkSize) {
            chunkBuffer = new char[chunkSize];
            chunkRemain = chunkSize;
        }
        if (chunkRemain > size) {
            p = chunkBuffer;
            chunkRemain -= size + 1;
            chunkBuffer += size + 1;
        }
        else
            p = new char[size + 1];
        memcpy(p, tmp.data(), size);
        p[size] = 0;
    }
    last = p;
    return p;
}

void stream_t::undo(const char* p) {
    assert(last == p);
    // allocated element size is always >=1 bytes to hold zero terminator 
    if (p < chunkBuffer && p >= chunkBuffer + chunkRemain - chunkSize) {
        chunkRemain += chunkBuffer - p;
        chunkBuffer -= chunkBuffer - p;
    }
    else
        delete[] p;
    last = 0;   
}

