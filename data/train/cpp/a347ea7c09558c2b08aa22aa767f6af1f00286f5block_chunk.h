#ifndef BLOCK_CHUNK_H_INCLUDED
#define BLOCK_CHUNK_H_INCLUDED

#include "util/position.h"
#include "stream/stream.h"
#include "util/variable_set.h"
#include "stream/compressed_stream.h"
#include <array>

using namespace std;

template <typename T, int32_t ChunkSizeXV = 16, int32_t ChunkSizeYV = 16, int32_t ChunkSizeZV = 16, bool TransmitCompressedV = true>
struct BlockChunk
{
    const PositionI basePosition;
    static constexpr int32_t chunkSizeX = ChunkSizeXV;
    static constexpr int32_t chunkSizeY = ChunkSizeYV;
    static constexpr int32_t chunkSizeZ = ChunkSizeZV;
    static_assert(chunkSizeX > 0, "chunkSizeX must be positive");
    static_assert(chunkSizeY > 0, "chunkSizeY must be positive");
    static_assert(chunkSizeZ > 0, "chunkSizeZ must be positive");
    static_assert((chunkSizeX & (chunkSizeX - 1)) == 0, "chunkSizeX must be a power of 2");
    static_assert((chunkSizeY & (chunkSizeY - 1)) == 0, "chunkSizeY must be a power of 2");
    static_assert((chunkSizeZ & (chunkSizeZ - 1)) == 0, "chunkSizeZ must be a power of 2");
    static constexpr bool transmitCompressed = TransmitCompressedV;
    mutable ChangeTracker changeTracker;
    constexpr BlockChunk(PositionI basePosition)
        : basePosition(basePosition)
    {
    }
    static constexpr PositionI getChunkBasePosition(PositionI pos)
    {
        return PositionI(pos.x & ~(chunkSizeX - 1), pos.y & ~(chunkSizeY - 1), pos.z & ~(chunkSizeZ - 1), pos.d);
    }
    static constexpr PositionI getChunkRelativePosition(PositionI pos)
    {
        return PositionI(pos.x & (chunkSizeX - 1), pos.y & (chunkSizeY - 1), pos.z & (chunkSizeZ - 1), pos.d);
    }
    array<array<array<T, chunkSizeZ>, chunkSizeY>, chunkSizeX> blocks;
    BlockChunk(const BlockChunk & rt)
        : basePosition(rt.basePosition), blocks(rt.blocks)
    {
        changeTracker.onChange();
    }
private:
    static void readInternal(shared_ptr<BlockChunk> chunk, stream::Reader &reader, VariableSet &variableSet)
    {
        for(int32_t x = 0; x < chunkSizeX; x++)
        {
            for(int32_t y = 0; y < chunkSizeY; y++)
            {
                for(int32_t z = 0; z < chunkSizeZ; z++)
                {
                    chunk->blocks[x][y][z] = (T)stream::read<T>(reader, variableSet);
                }
            }
        }
    }
    void writeInternal(stream::Writer &writer, VariableSet &variableSet) const
    {
        for(int32_t x = 0; x < chunkSizeX; x++)
        {
            for(int32_t y = 0; y < chunkSizeY; y++)
            {
                for(int32_t z = 0; z < chunkSizeZ; z++)
                {
                    stream::write<T>(writer, variableSet, blocks[x][y][z]);
                }
            }
        }
        changeTracker.onWrite(variableSet);
    }
    static bool checkPosition(PositionI p)
    {
        return p.x % chunkSizeX == 0 && p.y % chunkSizeY == 0 && p.z % chunkSizeZ == 0;
    }
    static void readTemplateParameters(stream::Reader &reader)
    {
        stream::read_limited<int32_t>(reader, chunkSizeX, chunkSizeX);
        stream::read_limited<int32_t>(reader, chunkSizeY, chunkSizeY);
        stream::read_limited<int32_t>(reader, chunkSizeZ, chunkSizeZ);
        stream::read_checked<bool>(reader, [](bool v){return v == transmitCompressed;});
    }
    static void writeTemplateParameters(stream::Writer &writer)
    {
        stream::write<int32_t>(writer, chunkSizeX);
        stream::write<int32_t>(writer, chunkSizeY);
        stream::write<int32_t>(writer, chunkSizeZ);
        stream::write<bool>(writer, transmitCompressed);
    }
public:
    static shared_ptr<BlockChunk> read(stream::Reader &reader, VariableSet &variableSet)
    {
        PositionI basePosition = stream::read_checked<PositionI>(reader, checkPosition);
        readTemplateParameters(reader);
        shared_ptr<BlockChunk> retval = shared_ptr<BlockChunk>(new BlockChunk(basePosition));
        if(transmitCompressed)
        {
            stream::ExpandReader expandReader(reader);
            readInternal(retval, expandReader, variableSet);
        }
        else
            readInternal(retval, reader, variableSet);
        return retval;
    }
    void write(stream::Writer &writer, VariableSet &variableSet) const
    {
        stream::write<PositionI>(writer, basePosition);
        writeTemplateParameters(writer);
        if(transmitCompressed)
        {
            stream::CompressWriter compressWriter(writer);
            writeInternal(compressWriter, variableSet);
            compressWriter.finish();
        }
        else
            writeInternal(writer, variableSet);
    }
    void onChange()
    {
        changeTracker.onChange();
    }
};

namespace stream
{
template <typename T, size_t ChunkSizeXV, size_t ChunkSizeYV, size_t ChunkSizeZV, bool TransmitCompressedV>
struct is_value_changed<BlockChunk<T, ChunkSizeXV, ChunkSizeYV, ChunkSizeZV, TransmitCompressedV>>
{
    bool operator ()(std::shared_ptr<const BlockChunk<T, ChunkSizeXV, ChunkSizeYV, ChunkSizeZV, TransmitCompressedV>> value, VariableSet &variableSet) const
    {
        if(value == nullptr)
            return false;
        return value->changeTracker.getChanged(variableSet);
    }
};
}

#endif // BLOCK_CHUNK_H_INCLUDED
