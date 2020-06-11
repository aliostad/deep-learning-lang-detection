//-----------------------
// This Class's Header --
//-----------------------
#include "Translator/ChunkPolicy.h"
#include "MsgLogger/MsgLogger.h"
//-----------------
// C/C++ Headers --
//-----------------
//-------------------------------
// Collaborating Class Headers --
//-------------------------------

//-----------------------------------------------------------------------
// Local Macros, Typedefs, Structures, Unions and Forward Declarations --
//-----------------------------------------------------------------------

//		----------------------------------------
// 		-- Public Function Member Definitions --
//		----------------------------------------

namespace {
  const char * logger = "Translator.ChunkPolicy";
}

namespace Translator {

//----------------
// Constructors --
//----------------
ChunkPolicy::ChunkPolicy(hsize_t chunkSizeTargetBytes,
                         int chunkSizeTargetObjects,
                         hsize_t maxChunkSizeBytes,
                         int minObjectsPerChunk,
                         int maxObjectsPerChunk,
                         int chunkCacheSizeTargetInChunks,
                         hsize_t maxChunkCacheSizeBytes)
  : m_chunkSizeTargetBytes(chunkSizeTargetBytes)
  , m_chunkSizeTargetObjects(chunkSizeTargetObjects)
  , m_maxChunkSizeBytes(maxChunkSizeBytes)
  , m_minObjectsPerChunk(minObjectsPerChunk)
  , m_maxObjectsPerChunk(maxObjectsPerChunk)
  , m_chunkCacheSizeTargetInChunks(chunkCacheSizeTargetInChunks)
  , m_maxChunkCacheSizeBytes(maxChunkCacheSizeBytes)
{
}

//--------------
// Destructor --
//--------------
ChunkPolicy::~ChunkPolicy ()
{
}

// Return chunk size in objects for a dataset
int ChunkPolicy::chunkSize(const hdf5pp::Type& dsType) const {
  const size_t obj_size = dsType.size();
  return chunkSize(obj_size);
}

int ChunkPolicy::chunkSize(size_t obj_size) const {
  int objectsPerChunk = m_chunkSizeTargetObjects > 0 ? m_chunkSizeTargetObjects : m_chunkSizeTargetBytes / obj_size;
  objectsPerChunk = std::min(objectsPerChunk, m_maxObjectsPerChunk);
  objectsPerChunk = std::max(objectsPerChunk, m_minObjectsPerChunk);
  int maxObjectsThatFitInMaxChunkSizeBytes = std::max((hsize_t)1,m_maxChunkSizeBytes/obj_size);
  objectsPerChunk = std::min(objectsPerChunk, maxObjectsThatFitInMaxChunkSizeBytes);

  MsgLog(logger,debug,"chunkSize() returning= " << objectsPerChunk
         << " typeSize=" << obj_size << " chunkSizeTargetObjects=" << m_chunkSizeTargetObjects
         << " chunkSizeTargetBytes=" << m_chunkSizeTargetBytes 
         << " chunkSizeBounds=[" << m_minObjectsPerChunk << ", " << m_maxObjectsPerChunk << "]"
         << " maxChunkBytes=" << m_maxChunkSizeBytes 
         << " most objects we can fit in maxChunkBytes=" << maxObjectsThatFitInMaxChunkSizeBytes);

  return objectsPerChunk;
}

// Return chunk cache size (in chunks) for a dataset.
int ChunkPolicy::chunkCacheSize(const hdf5pp::Type& dsType) const
{
  const size_t obj_size = dsType.size();
  return chunkCacheSize(obj_size);
}

int ChunkPolicy::chunkCacheSize(const size_t obj_size) const {
  hsize_t cacheSizeChunks = m_chunkCacheSizeTargetInChunks;
  if (cacheSizeChunks<1) MsgLog(logger,fatal,"target chunk cache size (in chunks) is less than 1");
  const int chunk_size = chunkSize(obj_size);
  const hsize_t chunk_size_bytes = chunk_size * obj_size;
  hsize_t cacheSizeBytes = cacheSizeChunks * chunk_size_bytes;
  if (cacheSizeBytes > m_maxChunkCacheSizeBytes) {
    cacheSizeChunks = std::max(hsize_t(1),m_maxChunkCacheSizeBytes/chunk_size_bytes);
  }
  MsgLog(logger,debug, "chunkCacheSize(): returning= "
         << cacheSizeChunks
         << " (chunks) obj_size=" << obj_size 
         << " chunk_size=" << chunk_size 
         << " target cache size (chunks)= " << cacheSizeChunks
         << " target cache size (bytes) = " << m_chunkCacheSizeTargetInChunks * chunk_size_bytes
         << " max cache size (bytes) = " << m_maxChunkCacheSizeBytes);

  return cacheSizeChunks;
}

void ChunkPolicy::chunkSizeTargetObjects(int val) {
  MsgLog(logger,trace,"chunkSizeTargetObjects being set to " << val);
  m_chunkSizeTargetObjects = val;
}

} // namespace Translator
