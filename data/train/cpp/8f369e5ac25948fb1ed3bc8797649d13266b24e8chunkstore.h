// chunkstore.h
//  Abstract interface to persistent chunk storage
//
#pragma once

#include <memory>

// Forward declarations
namespace xim {
    class Chunk;
}

namespace xim { namespace interface
{
    class ChunkStore
    {
    public:
        /**
         * Function: hasChunk
         *
         * Returns true if the store contains a chunk at the specified (x,z)
         * chunks coordinates.
         */
        virtual bool hasChunk(int32_t x, int32_t z) = 0;

        /**
         * Function: load
         *
         * Reads the chunk at (x,z) from persistent storage and returns it as
         * a fully initialized Chunk object.
         */
        virtual std::unique_ptr<Chunk> load(int32_t x, int32_t z) = 0;

        /**
         * Function: store
         *
         * Commits a map chunk to persistent storage at the specified (x,z)
         * chunk coordinates.
         */
        virtual void store(int32_t x, int32_t z, Chunk const& chunk) = 0;
    };

}} // namespace xim::interface

