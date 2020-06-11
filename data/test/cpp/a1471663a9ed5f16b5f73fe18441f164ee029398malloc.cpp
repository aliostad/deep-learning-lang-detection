#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define HEAP_SIZE 100
#define METADATA 2
#define MIN_CHUNK_SIZE 3


// In cpp, 
// constexpr uint32_t HEAP_SIZE = 100;

int the_heap[HEAP_SIZE];

void* allocateMemory(uint32_t size_in_bytes) {
	// Step 0: convert units
	uint32_t size = (size_in_bytes + sizeof(int) - 1) / sizeof(int); // rounds up

	// Step 1: find a block (first fit)
	uint32_t chunk = 0; // index of the bottom signature of the chunk
	while(chunk < HEAP_SIZE && the_heap[chunk] < size) {
		int block_size = the_heap[chunk];
		if (block_size < 0) {block_size = -block_size;}
		chunk = chunk + block_size + METADATA;	
	}
	// C standard, malloc returns null pointer
	if (chunk >= HEAP_SIZE) { return 0;}
	// What C probably should do:
	//assert(chunk < HEAP_SIZE);
	
	// Step 2: split the block if it's too big
	// Three is the minimum leftover block size
	// b/c anything less and we can't form 
	// another block. If that's the case, 
	// it isn't worth splitting.
	if (the_heap[chunk] - size >= MIN_CHUNK_SIZE) {
		uint32_t extra_size = the_heap[chunk] - size - METADATA;
		uint32_t extra_chunk = chunk + size + METADATA;
		the_heap[chunk] = the_heap[chunk + size + 1] =  size;
		the_heap[extra_chunk] = the_heap[extra_chunk + extra_size + 1] = extra_size;
	} else {
		size = the_heap[chunk];
	}
	// Step 3: mark the chunk busy
	the_heap[chunk] = -size;
	the_heap[chunk + size + 1] = -size;
	// Step 4: return address of first byte in block
	return &the_heap[chunk+1];
}	


// YOU CAN'T DEFRAGMENT THE HEAP SINCE YOU DON'T KNOW HOW MANY POINTERS YOUR USER WILL HAVE BASED UPON THE HEAP
// KNOW THIS FOR THE EXAM
// if you've got two open blocks divided by a busy block, there's nothing you can do
void deallocateMemory(void* p) {
	// Step 1: find the metadata
	int* block_address = (int*) p;
	uint32_t chunk = (block_address - &the_heap[0]) - 1; // index of block - 1

	// Step 2: mark the chunk as available
	the_heap[chunk] = -the_heap[chunk];
	the_heap[chunk + the_heap[chunk] + 1] = the_heap[chunk];

	// Step 3: combine with successor if available
	uint32_t size = the_heap[chunk];
	uint32_t next_chunk = chunk + size + METADATA;
	if (next_chunk < HEAP_SIZE && the_heap[next_chunk] > 0) { // If next block is available. && short circuits, if first condition fails the second condition will NEVER EXECUTE
		uint32_t next_chunk_size = the_heap[next_chunk];
		uint32_t new_size = size + next_chunk_size + METADATA;	
		the_heap[chunk] = new_size;
		size = new_size;
		the_heap[chunk + size + 1] = new_size;
	}
	// Step 4: combine with predecessor if available.
	uint32_t prev_chunk_top = chunk - 1;
   	if (prev_chunk_top < HEAP_SIZE	&& the_heap[prev_chunk_top] > 0) { // next block is available
		uint32_t prev_chunk_size = the_heap[prev_chunk_top];
		chunk = prev_chunk_top - prev_chunk_size - 1;
		uint32_t new_size = size + prev_chunk_size;
		the_heap[chunk] = new_size;
		size = new_size;
		the_heap[chunk + size + 1] = new_size;	
	}	
}
