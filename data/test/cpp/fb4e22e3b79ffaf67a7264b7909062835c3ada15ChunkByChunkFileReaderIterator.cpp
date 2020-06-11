#include "ChunkByChunkFileReaderIterator.h"

#include "ChunkByChunkFileReader.h"
#include "FileChunk.h"

ChunkByChunkFileReaderIterator::ChunkByChunkFileReaderIterator()
    : m_reader(nullptr)
    , m_sequenceNo(0)
{
}

ChunkByChunkFileReaderIterator::ChunkByChunkFileReaderIterator(
    ChunkByChunkFileReader * iReader , unsigned int iSequenceNo)
    : m_reader(iReader)
    , m_sequenceNo(iSequenceNo)
{
}

bool ChunkByChunkFileReaderIterator::operator !=(const ChunkByChunkFileReaderIterator & other) const
{
    return m_reader != other.m_reader || m_sequenceNo != other.m_sequenceNo;
}

FileChunk ChunkByChunkFileReaderIterator::operator *()
{
    return m_reader->chunkAt(m_sequenceNo);
}

ChunkByChunkFileReaderIterator & ChunkByChunkFileReaderIterator::operator ++()
{
    ++m_sequenceNo;
    return *this;
}
