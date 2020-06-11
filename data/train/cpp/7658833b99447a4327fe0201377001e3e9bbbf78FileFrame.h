#pragma once

#include "Chunk.h"
#include <string>

const int c_MaxChunkSize = 52428800;

class FileFrame {
public:
    FileFrame();
    ~FileFrame(){}

    void LoadChunk( std::string& filename );
    void WriteChunk( std::string& filename );
    int getFileLength( std::string& filename );
    int GetChunkId( void );

    bool IsFinalChunk( void );

    Chunk    m_Chunk;
    int      m_CurrentChunk; // index of chunk, 0 = 1st chunk
    unsigned m_TotalChunks;  // size of chunk(# of packets) 0 denotes 0 packets
    unsigned m_FileSize;
    bool m_Ready;
};


