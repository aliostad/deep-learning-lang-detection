#ifndef CHUNKBYCHUNKFILEREADER_H
#define CHUNKBYCHUNKFILEREADER_H

#include "ChunkByChunkFileReaderIterator.h"

#include <fstream>


class ChunkByChunkFileReader
{
public:
    typedef ChunkByChunkFileReaderIterator Iterator;
    Iterator begin() const;
    Iterator end() const;

    ChunkByChunkFileReader(const char fileName[]);
    ~ChunkByChunkFileReader();

    FileChunk chunkAt(unsigned int chunkNo);

private:
    std::ifstream m_inputFile;
    unsigned long long int m_fileSize;
    unsigned int m_lastChunk;
    unsigned int numberOfChunks();

    unsigned int m_nextChunkToRead;
    FileChunk readNextChunk();

    Iterator m_begin;
    Iterator m_end;
};

#endif // CHUNKBYCHUNKFILEREADER_H
