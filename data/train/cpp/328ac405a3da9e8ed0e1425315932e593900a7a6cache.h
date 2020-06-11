// cache.h
//
#pragma once

#include "typedefs.h"

#include <unordered_map>

namespace xim
{
    // Forward Declarations
    class Chunk;
    class ChunkPosition;
    namespace event {
        class NewChunkEvent;
    }

    class ChunkCache
    {
    public:
        ChunkCache(unsigned int max) : max_size(max)
        { }
        chunk_ptr get(ChunkPosition const& p);
        void add(ChunkPosition const& p, chunk_ptr chunk);
        void remove(ChunkPosition const& p);
        void handler(event::NewChunkEvent& e);
    private:
        unsigned int max_size;

        // HASH FUNCTION, Y U SO UGLY!?
        struct hash
        {
            size_t operator()(ChunkPosition const& p) const
            {
                // Cantor pairing function
                return 0.5*(p.x + p.z)*(p.x + p.z + 1) + p.z;
            }
        };

        typedef std::pair<ChunkPosition, chunk_ptr> ChunkPair;
        typedef std::list<ChunkPair> ChunkList;
        ChunkList list;
        std::unordered_map<ChunkPosition,
                           ChunkList::iterator,
                           hash> map;
    };
}

