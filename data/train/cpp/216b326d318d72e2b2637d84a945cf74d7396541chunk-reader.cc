#include "services/chunk-reader.h"

#include "base/asio-dispatcher.h"
#include "proto/block.pb.h"
#include "services/chunk-reader-impl.h"

namespace polar_express {

// static
unique_ptr<ChunkReader> ChunkReader::CreateChunkReaderForPath(
    const boost::filesystem::path& path) {
  return unique_ptr<ChunkReader>(new ChunkReader(path));
}

ChunkReader::ChunkReader(const boost::filesystem::path& path)
    : impl_(new ChunkReaderImpl(path)) {
}

ChunkReader::ChunkReader(
    const boost::filesystem::path& path, bool create_impl)
    : impl_(create_impl ? new ChunkReaderImpl(path) : nullptr) {
}

ChunkReader::~ChunkReader() {
}

void ChunkReader::ReadBlockDataForChunk(
    const Chunk& chunk, vector<byte>* block_data_for_chunk, Callback callback) {
  AsioDispatcher::GetInstance()->PostDiskBound(
      bind(&ChunkReader::ReadBlockDataForChunk,
           impl_.get(), chunk, block_data_for_chunk, callback));
}

}  // namespace polar_express

