#include "wmomodel.h"

//------------------------------------------------------------------------------
WmoModel::WmoModel( const BufferS_t &wmo_buf ) {
  // create an istream of our buffer
  std::stringbuf str_buf( wmo_buf );
  std::istream i_str( &str_buf );

  uint32_t chunk_size = 0;

  // read in chunk by chunk
  chunk_size = readChunkHead( i_str, "MVER", (char*)&_mverChunk, sizeof( MverChunk_s ) );
  chunk_size = readChunkHead( i_str, "MOHD", (char*)&_mohdChunk, sizeof( MohdChunk_s ) );
  
  // read MOTX filenames
  chunk_size = readChunkHead( i_str, "MOTX", (char*)&_motxChunk );
  if ( _motxChunk.size ) {
    _motxChunk.textureNames.resize( _motxChunk.size );
    i_str.read( &_motxChunk.textureNames[0], _motxChunk.size );
  }

  // read MOTM chunk and material structs for each BLP inside
  chunk_size = readChunkHead( i_str, "MOMT", (char*)&_momtChunk );
  if ( _momtChunk.size ) {
    _momtChunk.materials.resize( _momtChunk.size / sizeof( MomtChunk_s::Materials_s ) );
    i_str.read( (char*)&_momtChunk.materials[0], _momtChunk.size );
  }

  // read MOGN group names
  chunk_size = readChunkHead( i_str, "MOGN", (char*)&_mognChunk );
  if ( _mognChunk.size ) {
    _mognChunk.groupNames.resize( _mognChunk.size );
    i_str.read( &_mognChunk.groupNames[0], _mognChunk.size );  
  }

  // read MOGI chunk and its group informations
  chunk_size = readChunkHead( i_str, "MOGI", (char*)&_mogiChunk );
  if ( _mogiChunk.size ) {
    _mogiChunk.infos.resize( _mogiChunk.size / sizeof( MogiChunk_s::GroupInformation_s ) );
    i_str.read( (char*)&_mogiChunk.infos[0], _mogiChunk.size );
  }

  // read MOSB chunk: sky box
  chunk_size = readChunkHead( i_str, "MOSB", (char*)&_mosbChunk );
  i_str.seekg( _mosbChunk.size + i_str.tellg() ); // skip chunk

  // read MOPV chunk: portal vertices
  // TODO: PortalVertices_s structure corruptes memory on some occasions -> FIX IT!
  chunk_size = readChunkHead( i_str, "MOPV", (char*)&_mopvChunk );
  i_str.seekg( _mopvChunk.size + i_str.tellg() ); // skip chunk

  // read MOPT chunk: portal informations
  chunk_size = readChunkHead( i_str, "MOPT", (char*)&_moptChunk );
  if ( _moptChunk.size ) {
    _moptChunk.infos.resize( _moptChunk.size / sizeof( MoptChunk_s::PortalInformation_s ) );
    i_str.read( (char*)&_moptChunk.infos[0], _moptChunk.size );
  }

  // read MOPR chunk: portal refererences
  chunk_size = readChunkHead( i_str, "MOPR", (char*)&_moprChunk );
  if ( _moprChunk.size ) {
    _moprChunk.references.resize( _moprChunk.size / sizeof( MoprChunk_s::PortalReference_s ) );
    i_str.read( (char*)&_moprChunk.references[0], _moprChunk.size );
  }

  // read MOVV chunk
  chunk_size = readChunkHead( i_str, "MOVV", (char*)&_movvChunk );
  if ( _movvChunk.size ) {
    _movvChunk.content.resize( _movvChunk.size );
    i_str.read( (char*)&_movvChunk.content[0], _movvChunk.size );
  }

  // read MOVB chunk
  chunk_size = readChunkHead( i_str, "MOVB", (char*)&_movbChunk );
  i_str.seekg( _movbChunk.size + i_str.tellg() ); // skip chunk

  // read MOLT chunk: lighting information
  chunk_size = readChunkHead( i_str, "MOLT", (char*)&_moltChunk );
  if ( _moltChunk.size ) {
    _moltChunk.infos.resize( _moltChunk.size / sizeof( MoltChunk_s::LightInformation_s ) );
    i_str.read( (char*)&_moltChunk.infos[0], _moltChunk.size );
  }

  // read MODS chunk: doodad sets
  chunk_size = readChunkHead( i_str, "MODS", (char*)&_modsChunk );
  i_str.seekg( _modsChunk.size + i_str.tellg() ); // skip chunk

  // read MODN chunk: doodad names
  chunk_size = readChunkHead( i_str, "MODN", (char*)&_modnChunk );
  if ( _modnChunk.size ) {
    _modnChunk.doodadNames.resize( _modnChunk.size );
    i_str.read( (char*)&_modnChunk.doodadNames[0], _modnChunk.size );
  }

  // read MODD chunk: doodad informations
  chunk_size = readChunkHead( i_str, "MODD", (char*)&_moddChunk );
  if ( _moddChunk.size ) {
    _moddChunk.infos.resize( _moddChunk.size / sizeof( ModdChunk_s::DoodadInformation_s ) );
    i_str.read( (char*)&_moddChunk.infos[0], _moddChunk.size );
  }
}

//------------------------------------------------------------------------------
WmoModel::~WmoModel() {
  for ( WmoGroups_t::iterator iter = _wmoGroups.begin();
        iter != _wmoGroups.end();
        ++iter ) {
    delete *iter;
  }

  _wmoGroups.clear();
}

//------------------------------------------------------------------------------
void WmoModel::loadGroups( const std::string wmo_name, MpqHandler &mpq_h ) {
  // world\maps\some\building.wmo -> world\maps\some\building
  std::string group_name = wmo_name.substr( 0, wmo_name.size() - 4 );
  char group_index[5];

  for ( int i = 0; i < _mohdChunk.numGroups; i++ ) {
    sprintf_s( group_index, 5, "_%03d", i );
    // "world\maps\some\building" + "_00i" + ".wmo"
    std::string group_filename = group_name + group_index + std::string( ".wmo" );
    
    // load file and push to vector
    BufferS_t grp_buf;
    mpq_h.getFile( group_filename, &grp_buf );
    _wmoGroups.push_back( new WmoGroup( grp_buf ) );
  }
}

//------------------------------------------------------------------------------
void WmoModel::getIndices( Indices32_t *indices, uint32_t filter, uint32_t off ) const {
  uint32_t index_off = 0;
  for ( WmoGroups_t::const_iterator iter = _wmoGroups.begin();
        iter != _wmoGroups.end();
        ++iter ) {
    // get group indices
    const Indices16_t &grp_indices = (*iter)->getMoviChunk().indices;
    const Vertices_t &grp_vertices = (*iter)->getMovtChunk().vertices;
    Indices32_t increment( grp_indices.begin(), grp_indices.end() );

    // increment indices
    std::vector<uint32_t> add( grp_indices.size(), off + index_off );
    std::transform( increment.begin(), increment.end(), add.begin(),
                    increment.begin(), std::plus<uint32_t>() );

    // filter vertices by triangle material info
    size_t num_triangles = grp_indices.size() / 3;
    for ( int i = 0; i < num_triangles; i++ ) {
      if ( !((*iter)->getMopyChunk().infos[i].flags & filter) ) {
        increment[i*3+0] = -1;
        increment[i*3+1] = -1;
        increment[i*3+2] = -1;
      }
    }

    // add new indices to destination
    indices->insert( indices->end(), increment.begin(), increment.end() );
    index_off += grp_vertices.size();
  }
}

//------------------------------------------------------------------------------
void WmoModel::getVertices( Vertices_t *vertices ) const {
  for ( WmoGroups_t::const_iterator iter = _wmoGroups.begin();
        iter != _wmoGroups.end();
        ++iter ) {
    // get vertices from group file
    const Vertices_t &grp_vertices = (*iter)->getMovtChunk().vertices;
    vertices->insert( vertices->end(), grp_vertices.begin(), grp_vertices.end() );
  }
}

//------------------------------------------------------------------------------
void WmoModel::getNormals( Normals_t *normals ) const {
  for ( WmoGroups_t::const_iterator iter = _wmoGroups.begin();
        iter != _wmoGroups.end();
        ++iter ) {
    // get normals from group file
    const Normals_t &grp_normals = (*iter)->getMonrChunk().normals;
    normals->insert( normals->end(), grp_normals.begin(), grp_normals.end() );
  }
}

//------------------------------------------------------------------------------
const ModdChunk_s& WmoModel::getModdChunk() const {
  return _moddChunk;
}

//------------------------------------------------------------------------------
const ModnChunk_s& WmoModel::getModnChunk() const {
  return _modnChunk;
}