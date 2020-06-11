//--------------------------------------------------------------------------
// File and Version Information:
// 	$Id$
//
// Description:
//	Class CvtOptions...
//
// Author List:
//      Andy Salnikov
//
//------------------------------------------------------------------------

//-----------------------
// This Class's Header --
//-----------------------
#include "O2OTranslator/CvtOptions.h"

//-----------------
// C/C++ Headers --
//-----------------

//-------------------------------
// Collaborating Class Headers --
//-------------------------------

//-----------------------------------------------------------------------
// Local Macros, Typedefs, Structures, Unions and Forward Declarations --
//-----------------------------------------------------------------------

namespace {

  // constants for algorithm
  const hsize_t abs_max_chunk_size = 100*1024*1024;    // absolute maximum on chunk size in bytes
  const unsigned max_objects_per_chunk = 2048;         // absolute maximum on chunk size in objects
  const unsigned min_objects_per_chunk = 50;           // absolute minimum on chunk size in objects

  // user-provided chunk size, overrides our defaults
  hsize_t g_chunkSize = 0;
}

//		----------------------------------------
// 		-- Public Function Member Definitions --
//		----------------------------------------

namespace O2OTranslator {

// Returns HDF5 chunk size counted in objects of given HDF5 type.
hsize_t 
CvtOptions::chunkSize(const hdf5pp::Type& type) const
{
  return chunkSize(m_chunkSizeBytes, type, ::g_chunkSize);
}

/// Set chunk size, if size 0 is given then use internally-calculated size.
void 
CvtOptions::setChunkSize(hsize_t chunkSize)
{
  ::g_chunkSize = chunkSize;
}

/**
 *  @brief Returns HDF5 chunk size counted in objects of given HDF5 type.
 *
 *  This method calculates chunk size like it is described above but
 *  instead of taking into account value set with the setChunkSize() method
 *  it uses additional parameter.
 */
hsize_t
CvtOptions::chunkSize(hsize_t chunkSizeBytes, const hdf5pp::Type& type, hsize_t chunkSize)
{
  size_t obj_size = type.size();
  hsize_t chunk = chunkSize > 0 ? chunkSize : chunkSizeBytes / obj_size;

  // chunk_size is a desirable size, make sure that number of objects is not
  // too large or too small
  if (chunk > ::max_objects_per_chunk) {
    chunk = ::max_objects_per_chunk;
  } else if (chunk < ::min_objects_per_chunk) {
    chunk = ::min_objects_per_chunk;
    if (chunk*obj_size > ::abs_max_chunk_size) {
      chunk = ::abs_max_chunk_size / obj_size;
      if (chunk == 0) chunk = 1;
    }
  }
  return chunk;
}

} // namespace O2OTranslator
