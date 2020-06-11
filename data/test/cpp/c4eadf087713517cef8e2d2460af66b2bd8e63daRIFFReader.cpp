#include "common.h"
#include "RIFFReader.h"
#include "RIFFChunk.h"

#include "Reader.h"

namespace CMI
{

RIFFReader::RIFFReader(Reader* file) :
    _file(file),
    _chunkStack()
{
}

RIFFReader::~RIFFReader()
{
    while (!_chunkStack.empty())
    {
        delete _chunkStack.top();
        _chunkStack.pop();
    }
}

UInt32 RIFFReader::descend()
{
    RIFFChunk* chunk = (_chunkStack.size() > 0) ? _chunkStack.top() : 0;

    // Are we still within the bounds of the containing list?
    if ((chunk == 0) ||
        (_file->getPosition() < chunk->getPosition() + chunk->getSize() + 8))
    {
        chunk = new RIFFChunk();
        chunk->readHead(_file);
        _chunkStack.push(chunk);
        return chunk->getId();
    }
    return 0;
}

void RIFFReader::ascend()
{
    RIFFChunk* chunk = _chunkStack.top();
    _chunkStack.pop();
    _file->setPosition(chunk->getPosition() + chunk->getSize() + 8, Reader::BEGIN);
    delete chunk;
}

void RIFFReader::read(UInt8* buffer, UInt32 length)
{
    _file->read(buffer, length);
}

} //namespace CMI
