// "Provider.cpp"
//

#include "WorldMacros.h"

#include "Base.h"

#include "Provider.h"

using namespace update::world::chunk;


// --------------------------------------------------------------------------------------------------------------------
//  Sets _nullChunk
//
Provider::Provider( update::world::Chunk* nullChunk ) :
	_nullChunk( nullChunk )
{

}


// --------------------------------------------------------------------------------------------------------------------
//  Deletes keys and map
//
Provider::~Provider( void )
{
	_chunkMap.clear();
}


// --------------------------------------------------------------------------------------------------------------------
//  Adds chunk pointer to the specified position in the hashmap
//
void Provider::insertChunk( glm::ivec3 chunkPos, update::world::Chunk* chunk )
{
	_chunkMap[chunkPos] = chunk;
}


// --------------------------------------------------------------------------------------------------------------------
//  Returns pointer to the chunk at the specified position
//  Returns _nullChunk if key is not registered
//
update::world::Chunk* Provider::getChunk( glm::ivec3 chunkPos ) const
{
	return ( _chunkMap.find( chunkPos ) == _chunkMap.end() ) ? _nullChunk : _chunkMap.at( chunkPos );
}
