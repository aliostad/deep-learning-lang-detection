#include <iostream>
#include <typeinfo>

#include "slim/memory/ArenaChunk.hpp"
#include "slim/memory/DirtyChunk.hpp"
#include "slim/memory/QueueChunk.hpp"
#include "slim/memory/Manager.hpp"
#include "slim/memory/SmartStackChunk.hpp"
#include "slim/memory/StackChunk.hpp"

using namespace slim::memory;

template <class CHUNK>
int	chunk_test(std::size_t size)
{
    Chunk&	chunk = Manager::instance.createChunk<CHUNK>(size, typeid(CHUNK).name());
    void*	ptr1;
    void*	ptr2;
    void*	ptr3;

    ptr1 = chunk.alloc(500);
    ptr2 = chunk.alloc(1000);
    chunk.free(ptr2);
    ptr3 = chunk.alloc(5000);
    chunk.free(ptr1);
    ptr2 = chunk.alloc(4200);
    chunk.free(ptr2);
    chunk.free(ptr3);

    return 0;
}

int	main()
{
    Manager::instance.init();

    chunk_test<ArenaChunk>(12000);
    chunk_test<DirtyChunk>(10000);
    chunk_test<SmartStackChunk>(10000);

    Manager::instance.destroy();

    return 0;
}
