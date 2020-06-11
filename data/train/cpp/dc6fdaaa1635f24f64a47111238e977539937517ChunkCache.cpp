#include "ChunkCache.hpp"
#include <cstdlib>
#include <iostream>

using namespace vox::engine;

ChunkCache::ChunkCache() {
    _prov = NULL;
}

ChunkCache::~ChunkCache() {
    std::cout << "Deleted Chunk cache" << std::endl;
}

Chunk* ChunkCache::Get(int CX, int CY, int CZ) {
    Chunk* tr = _cache.Get(CX, CY, CZ);
    if (tr == NULL
            || tr->GetX() != CX
            || tr->GetY() != CY
            || tr->GetZ() != CZ) {
        if (tr != NULL) {
            delete tr;
        }
        if (_prov != NULL) {
            tr = _prov->GetChunk(CX, CY, CZ);
            _cache.Set(CX, CY, CZ, tr);
        } else {
            std::cout << "Error: Asked chunk cache for chunk without setting a provider!" << std::endl;
            std::exit(-1);
        }
    }
    return tr;
}

void ChunkCache::SetChunkProvider(ChunkProvider* Provider) {
    _prov = Provider;
}
