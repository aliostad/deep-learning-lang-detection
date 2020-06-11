
#include <iostream>
#include "MemoryManager.h"

int main() {

    auto manager = MemoryManager(50000);
    manager.dump();

    void *block1 = manager.alloc(50);
    manager.dump();

    void *block2 = manager.alloc(20);
    manager.dump();

    void *block3 = manager.alloc(7000);
    manager.dump();

    void* block4 = manager.alloc(45000);

    manager.free(block1);
    manager.dump();

    void *block7 = manager.realloc(block2, 3000);
    manager.dump();

    manager.free(block2);
    manager.dump();

    manager.free(block7);
    manager.dump();

    manager.free(block3);
    manager.dump();

    return EXIT_SUCCESS;
}