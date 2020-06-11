
#ifndef CHUNK_H_
#define CHUNK_H_

/**
 * This class represents a Chunk, including its data and its length
 *
*/
class Chunk{
private:
    char* buffer;
    const int length;
    
public:
    Chunk(const char* const buffer, const int length);
    
    ~Chunk();

    /**
     * Returns the size of this chunk's data segment
     *
    */
    int size() const;
    
    /**
     * Returns the data at index of chunk's buffer
     *
    */
    char operator[](int index);
    
private:
    // No copy, assignment
    Chunk(Chunk & other);
    Chunk & operator=(Chunk & other);
};

#endif
