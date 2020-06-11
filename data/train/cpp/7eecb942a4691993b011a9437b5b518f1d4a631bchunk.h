#ifndef TWF_CHUNK_H
#define TWF_CHUNK_H

#include <cstdint>
#include <tr1/memory>

const int TILES_ACROSS_CHUNK = 8;
const int TILES_ACROSS_CHUNK_SQUARED = TILES_ACROSS_CHUNK * TILES_ACROSS_CHUNK;

class Chunk {
public:
    typedef std::tr1::shared_ptr<Chunk> ptr;

    Chunk(IChunkGrid* parent):
        parent_(parent) {
    }
    
    void set_tile_id(const uint32_t i, const uint32_t tile_id) {
        assert(i < TILES_ACROSS_CHUNK_SQUARED);
        tiles_[i] = tile_id;
        rebuild_map();
    }
    
private:
    IChunkGrid* parent_;
    
    void rebuild_map() {}
    
    uint32_t tiles_[TILES_ACROSS_CHUNK_SQUARED];
    std::vector<uint8_t> map_;
};

#endif
