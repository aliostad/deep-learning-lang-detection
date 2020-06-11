#ifndef MANAGED_MEMORY_CHUNK_H
#define MANAGED_MEMORY_CHUNK_H
#include <cstddef>
#include <functional>
#include "interpreter_export.h"

class INTERPRETER_EXPORT ManagedMemoryChunk
{
public:
    using destructor_t = std::function<void(void *)>;

    ManagedMemoryChunk() {};
    explicit ManagedMemoryChunk(std::size_t chunkSize, destructor_t destructor = [](void *) {});
    ~ManagedMemoryChunk();

    /*ManagedMemoryChunk(const ManagedMemoryChunk &) = delete;
    ManagedMemoryChunk & operator=(const ManagedMemoryChunk &) = delete;*/

    ManagedMemoryChunk(ManagedMemoryChunk && other);
    ManagedMemoryChunk & operator=(ManagedMemoryChunk && other);

    operator void * ();
private:
    void * managedData{};
    std::size_t managedDataSize{};
    destructor_t destructor;
    void releaseManagedData();
};

#endif
