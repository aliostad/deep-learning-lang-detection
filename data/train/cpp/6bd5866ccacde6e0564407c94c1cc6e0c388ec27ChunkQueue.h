#ifndef CHUNK_QUEUE_H_
#define CHUNK_QUEUE_H_

/**
 * A thread-safe wrapper on an stl container for use as our Chunk Queue of
 * of chunk pointers.
 *
*/

#include <list>
#include <pthread.h>
#include "Chunk.h"

class ChunkQueue{
	std::list< Chunk* >chunkQueue;

    pthread_mutex_t* queueLock;

public:
    /**
     *  Creates the queue
    */
    ChunkQueue();
    
    /**
     *  Destructor
    */
    ~ChunkQueue();

    /**
     * Checks the size of the queue
     * Is Thread Safe
    */
    int size();
    
    /**
     * Removes the first Chunk from the queue.
     * Is Thread Safe
    */
    void pop();
    
    /**
     * Returns the first chunk from the queue, but does not remove it
     * Is Thread Safe
    */
    Chunk* front();
    
    /**
     * Adds a chunk to end of the queue
     * Is Thread Safe
    */
    void push(Chunk* chunk);
    
private:
    // No copy or assignment
    ChunkQueue(ChunkQueue& other);
	ChunkQueue & operator=(ChunkQueue & other);
};

#endif
