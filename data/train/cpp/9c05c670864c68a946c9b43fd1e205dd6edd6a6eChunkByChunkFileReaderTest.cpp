#include "ChunkByChunkFileReaderTest.h"

#include "Log.h"
#include <iostream>

// classes to test
#include "ChunkByChunkFileReader.h"
#include "FileChunk.h"

ChunkByChunkFileReaderTest::ChunkByChunkFileReaderTest()
{
}

void ChunkByChunkFileReaderTest::run()
{
    ChunkByChunkFileReader reader("test_file");
    ChunkByChunkFileReader::Iterator iterator;
    iterator = reader.begin();
    Log::get() << "Begin equals end: " << !(iterator != reader.end()) << Log::Endl;
    for(FileChunk chunk : reader)
    {
        Log::get() << chunk.data() << Log::Endl;
    }
}
