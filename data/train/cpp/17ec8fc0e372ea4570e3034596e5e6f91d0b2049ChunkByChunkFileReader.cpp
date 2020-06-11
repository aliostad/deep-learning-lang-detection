#include "ChunkByChunkFileReader.h"

#include <iostream>
#include <cmath>

#include "Log.h"
#include "FileChunk.h"
#include "ChunkByChunkFileReaderIterator.h"

ChunkByChunkFileReader::ChunkByChunkFileReader(const char fileName[])
    : m_lastChunk(0)
    , m_nextChunkToRead(0)
{
    m_inputFile.open(fileName, std::ios::in);
    m_inputFile.exceptions ( std::ifstream::failbit | std::ifstream::badbit );
    if ( !m_inputFile.is_open() )
    {
        std::cerr << "Could not open file [" << fileName << "]" << std::endl;
        exit(-1);
    }
    // find out the size of the file:
    m_inputFile.seekg(0, std::ios::end);
    m_fileSize = m_inputFile.tellg();
    m_lastChunk = numberOfChunks() - 1;
    m_inputFile.seekg(std::ios::beg);

    m_begin = ChunkByChunkFileReaderIterator(this, 0);
    m_end = ChunkByChunkFileReaderIterator(this, m_lastChunk + 1);

    Log::get() << "Constructing reader for file [" << fileName << "]" << Log::Endl;
    Log::get() << "File size: " << m_fileSize << Log::Endl;
    Log::get() << "Last chunk: " << m_lastChunk << Log::Endl;
    Log::get() << "Chunk ByteSize: " << ChunkByteSize << Log::Endl;
}

unsigned int ChunkByChunkFileReader::numberOfChunks()
{
    return static_cast<unsigned int>(
                std::ceil(
                    static_cast<float>(m_fileSize) / static_cast<float>(ChunkByteSize)
                    )
                );
}

FileChunk ChunkByChunkFileReader::readNextChunk()
{
    FileChunk chunk;
    chunk.init();
    if (m_nextChunkToRead == m_lastChunk)
    {
        unsigned int remaining = m_fileSize - m_lastChunk * ChunkByteSize;
        m_inputFile.read(chunk.dataPtr(), remaining);
        chunk.setSize(remaining);
    }
    else
    {
        m_inputFile.read(chunk.dataPtr(), ChunkByteSize);
        chunk.setSize(ChunkByteSize);
    }
    ++m_nextChunkToRead;

    Log::get() << "[" << chunk.data() << "] " << chunk.size() << " bytes read" << Log::Endl;

    return chunk;
}

FileChunk ChunkByChunkFileReader::chunkAt(unsigned int chunkNo)
{
    Log::get() << "Reading chunk #" << chunkNo << Log::Endl;
    FileChunk returnValue;
    if (chunkNo <= m_lastChunk)
    {
        if (chunkNo == m_nextChunkToRead)
        {
            returnValue = readNextChunk();
        }
        else
        {
            std::cerr << "Trying to read chunks not in order, which is not supported." << std::endl;
            exit(-1);
        }
    }
    else
    {
        std::cerr << "Trying to read invalid chunk #" << chunkNo << std::endl;
        exit(-1);
    }
    return returnValue;
}

ChunkByChunkFileReaderIterator ChunkByChunkFileReader::begin() const
{
    return m_begin;
}

ChunkByChunkFileReaderIterator ChunkByChunkFileReader::end() const
{
    return m_end;
}

ChunkByChunkFileReader::~ChunkByChunkFileReader()
{
    m_inputFile.close();
}
