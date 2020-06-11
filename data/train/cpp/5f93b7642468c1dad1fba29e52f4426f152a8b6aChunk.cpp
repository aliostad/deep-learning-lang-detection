#include "Chunk.h"
using namespace std;
using namespace sf;
using namespace tgui;

namespace kg
{
	std::string Chunk::getChunkSavename( const ChunkPosition& chunkPosition )
	{
		return "Chunk#" + to_string( chunkPosition.worldLayer ) + "#" + to_string( chunkPosition.x ) + "#" + to_string( chunkPosition.y );
	}

	bool Chunk::operator==( const Chunk& rhs ) const
	{
		return m_position == rhs.m_position;
	}

	Chunk::Chunk( const ChunkPosition& position )
		:m_position( position )
	{ }

	const ChunkPosition& Chunk::getPosition() const
	{
		return m_position;
	}

	void Chunk::addEntity( Entity* entity )
	{
		if( calculateChunkPositionForPosition2d( entity->getComponent<Transformation>()->getPosition() ) != m_position )
			throw exception();
		if( m_position == Position2d( 0, 0, 0 ) )
			int a = 0;

		//update entityData
		auto transformationComponent = entity->getComponent<Transformation>();
		transformationComponent->setChunkPostion( m_position );

		m_entities.push_back( entity );
	}

	void Chunk::removeEntity( Entity* entity )
	{
		//update entityData
		auto transformationComponent = entity->getComponent<Transformation>();
		//transformationComponent->removeChunkPosition();

		m_entities.erase( std::remove( m_entities.begin(), m_entities.end(), entity ), m_entities.end() );
	}

	const World::EntityPointerContainer& Chunk::getEntities() const
	{
		return m_entities;
	}

	Chunk::State Chunk::getState() const
	{
		return m_state;
	}

	std::string Chunk::getSavename() const
	{
		return getChunkSavename( m_position );
	}

	ChunkPosition Chunk::calculateChunkPositionForPosition2d( const Position2d& position2d )
	{
		ChunkPosition chunkPosition( position2d.x / Constants::CHUNK_SIZE,
									 position2d.y / Constants::CHUNK_SIZE,
									 position2d.worldLayer );

		if( position2d.x < 0 )
			chunkPosition.x -= 1;

		if( position2d.y < 0 )
			chunkPosition.y -= 1;

		return chunkPosition;
	}

	void Chunk::setState( Chunk::State state )
	{
		m_state = state;
	}
}