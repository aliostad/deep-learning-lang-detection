#include <cstring>
#include <chunkInfo.hpp>
#include <filePiece.hpp>
#include <sha1hash.hpp>

namespace torrent{

    ChunkInfo::ChunkInfo()
    {
    }

    ChunkInfo::~ChunkInfo()
    {
    }

    ChunkInfo::ChunkInfo(size_t id, unsigned char *hash)
    : m_id(id), m_hash(SHA1Hash(hash))
    {
    }

    ChunkInfo::ChunkInfo(size_t id, SHA1Hash hash)
    : m_id(id), m_hash(hash)
    {
    }

    void ChunkInfo::addFilePiece(const FilePiece& fp)
    {
        m_file_pieces.push_back(fp);
    }

    void ChunkInfo::setChunkId(size_t id)
    {
        m_id = id;
    }

}
