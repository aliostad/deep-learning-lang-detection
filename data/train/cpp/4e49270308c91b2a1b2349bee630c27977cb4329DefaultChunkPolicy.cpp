//--------------------------------------------------------------------------
// File and Version Information:
// 	$Id$
//
// Description:
//	Class DefaultChunkPolicy...
//
// Author List:
//      Andy Salnikov
//
//------------------------------------------------------------------------

//-----------------------
// This Class's Header --
//-----------------------
#include "psddl_hdf2psana/DefaultChunkPolicy.h"

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

namespace psddl_hdf2psana {

//----------------
// Constructors --
//----------------
DefaultChunkPolicy::DefaultChunkPolicy(hsize_t chunkSizeTargetBytes,
    int chunkSizeTarget,
    hsize_t maxChunkSizeBytes,
    int minObjectsPerChunk,
    int maxObjectsPerChunk,
    hsize_t minChunkCacheSize,
    hsize_t maxChunkCacheSize)
  : m_chunkSizeTargetBytes(chunkSizeTargetBytes)
  , m_maxChunkSizeBytes(maxChunkSizeBytes)
  , m_chunkSizeTarget(chunkSizeTarget)
  , m_minObjectsPerChunk(minObjectsPerChunk)
  , m_maxObjectsPerChunk(maxObjectsPerChunk)
  , m_minChunkCacheSize(minChunkCacheSize)
  , m_maxChunkCacheSize(maxChunkCacheSize)
{

}

//--------------
// Destructor --
//--------------
DefaultChunkPolicy::~DefaultChunkPolicy ()
{
}

// Return chunk size in objects for a dataset
int
DefaultChunkPolicy::chunkSize(const hdf5pp::Type& dsType) const
{
  const size_t obj_size = dsType.size();
  int chunk = m_chunkSizeTarget > 0 ? m_chunkSizeTarget : m_chunkSizeTargetBytes / obj_size;

  // chunk_size is a target size, make sure that number of objects is not
  // too large or too small
  if (chunk > m_maxObjectsPerChunk) {
    chunk = m_maxObjectsPerChunk;
  } else if (chunk < m_minObjectsPerChunk) {
    chunk = m_minObjectsPerChunk;
  }
  if (chunk*obj_size > m_maxChunkSizeBytes) {
    chunk = m_maxChunkSizeBytes / obj_size;
    if (chunk == 0) chunk = 1;
  }
  return chunk;
}

// Return chunk cache size (in chunks) for a dataset.
int
DefaultChunkPolicy::chunkCacheSize(const hdf5pp::Type& dsType) const
{
  const int chunk_size = chunkSize(dsType);

  hsize_t chunk_size_bytes = chunk_size * dsType.size();
  hsize_t chunk_cache_size = 1;
  if (chunk_size_bytes <= m_minChunkCacheSize/2) {
    chunk_cache_size = m_minChunkCacheSize/chunk_size_bytes;
  } else if (chunk_size_bytes <= m_maxChunkCacheSize/2) {
    chunk_cache_size *= 2;
  }
  return chunk_cache_size;
}

} // namespace psddl_hdf2psana
