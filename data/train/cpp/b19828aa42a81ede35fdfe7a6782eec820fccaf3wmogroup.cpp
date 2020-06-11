#include "wmogroup.h"

//------------------------------------------------------------------------------
WmoGroup::WmoGroup( BufferS_t &grp_buf ) {
  // create an istream of our buffer
  std::stringbuf str_buf( grp_buf );
  std::istream i_str( &str_buf );

  uint32_t chunk_size = 0;
  // read in chunk by chunk
  chunk_size = readChunkHead( i_str, "MVER", (char*)&_mverChunk, sizeof( MverChunk_s ) );
  chunk_size = readChunkHead( i_str, "MOGP", (char*)&_mogpChunk, sizeof( MogpChunk_s ) );

  // read MOPY chunk: material infos
  chunk_size = readChunkHead( i_str, "MOPY", (char*)&_mopyChunk );
  if ( _mopyChunk.size ) {
    _mopyChunk.infos.resize( _mopyChunk.size / sizeof( MopyChunk_s::MaterialInformation_s ) );
    i_str.read( (char*)&_mopyChunk.infos[0], _mopyChunk.size );
  }

  // read MOVI chunk: vertex indices
  chunk_size = readChunkHead( i_str, "MOVI", (char*)&_moviChunk );
  if ( _moviChunk.size ) {
    _moviChunk.indices.resize( _moviChunk.size / sizeof( uint16_t ) );
    i_str.read( (char*)&_moviChunk.indices[0], _moviChunk.size );
  }

  // read MOVT chunk: vertices
  chunk_size = readChunkHead( i_str, "MOVT", (char*)&_movtChunk );
  if ( _movtChunk.size ) {
    _movtChunk.vertices.resize( _movtChunk.size / sizeof( glm::vec3 ) );
    i_str.read( (char*)&_movtChunk.vertices[0], _movtChunk.size );
  }

  // read MONR chunk: normals
  chunk_size = readChunkHead( i_str, "MONR", (char*)&_monrChunk );
  if ( _monrChunk.size ) {
    _monrChunk.normals.resize( _monrChunk.size / sizeof( glm::vec3 ) );
    i_str.read( (char*)&_monrChunk.normals[0], _monrChunk.size );
  }

  // read MOTV chunk: texture coordinates
  chunk_size = readChunkHead( i_str, "MOTV", (char*)&_motvChunk );
  if ( _motvChunk.size ) {  
    _motvChunk.texCoords.resize( _motvChunk.size / sizeof( glm::vec2 ) );
    i_str.read( (char*)&_motvChunk.texCoords[0], _motvChunk.size );
  }
}

//------------------------------------------------------------------------------
const MopyChunk_s& WmoGroup::getMopyChunk() const {
  return _mopyChunk;
}

//------------------------------------------------------------------------------
const MoviChunk_s& WmoGroup::getMoviChunk() const {
  return _moviChunk;
}

//------------------------------------------------------------------------------
const MovtChunk_s& WmoGroup::getMovtChunk() const {
  return _movtChunk;
}

//------------------------------------------------------------------------------
const MonrChunk_s& WmoGroup::getMonrChunk() const {
  return _monrChunk;
}

//------------------------------------------------------------------------------
const MotvChunk_s& WmoGroup::getMotvChunk() const {
  return _motvChunk;
}