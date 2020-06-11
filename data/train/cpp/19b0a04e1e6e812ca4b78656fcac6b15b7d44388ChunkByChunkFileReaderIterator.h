#ifndef CHUNKBYCHUNKFILEREADERITERATOR_H
#define CHUNKBYCHUNKFILEREADERITERATOR_H

class FileChunk;
class ChunkByChunkFileReader;

class ChunkByChunkFileReaderIterator
{
public:
    ChunkByChunkFileReaderIterator();
    ChunkByChunkFileReaderIterator(ChunkByChunkFileReader * reader, unsigned int sequenceNo);

    // Those operators are necessary for the range construct.
    bool operator!=(const ChunkByChunkFileReaderIterator & other) const;
    ChunkByChunkFileReaderIterator & operator++();
    FileChunk operator*();

private:
    ChunkByChunkFileReader * m_reader;
    unsigned int m_sequenceNo;
};

#endif // CHUNKBYCHUNKFILEREADERITERATOR_H
