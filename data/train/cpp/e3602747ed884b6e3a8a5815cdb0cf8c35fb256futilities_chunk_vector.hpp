//          Matthew Avery Coder 2012 - 2013.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
#ifndef UTILITIES_CHUNK_VECTOR
#define UTILITIES_CHUNK_VECTOR

#include <memory>
#include <vector>
#include <cstdint>

#define CHUNK_VECTOR_DEFAULT_SIZE 1024

//debug#include <iostream>

namespace Utilities {


typedef std::vector<uint8_t> chunk_t;
typedef std::unique_ptr<chunk_t> chunk_up;
typedef std::vector<chunk_up> vector_chunks_t;

class ChunkVector {
    public:
        typedef vector_chunks_t::iterator iterator;
        typedef vector_chunks_t::const_iterator const_iterator;

        ChunkVector(uint64_t chunk_size = CHUNK_VECTOR_DEFAULT_SIZE);
        uint64_t size() const;
        uint8_t& at(uint64_t i);

        uint8_t& last_chunk();
        uint8_t& new_chunk();
        uint64_t chunk_size() const;
        void close_last_chunk(const uint64_t chunk_size);
        uint8_t& first();
        const_iterator chunk_cbegin() const;
        const_iterator chunk_cend() const;
        iterator chunk_begin();
        iterator chunk_end();
        
    private:
        vector_chunks_t chunk_vector_;
        bool open_;
        uint64_t chunk_size_;
};

typedef std::shared_ptr<ChunkVector> ChunkVector_sp;
}

#endif
