#include "Chunk3dContainer.hpp"

Chunk3dContainer::Chunk3dContainer() : mAllChunks(), mPool(), mManager(0)
{
}



Chunk * Chunk3dContainer::create(const ChunkCoordinate &position)
{
	Chunk * chunk = mPool.getFreeChunk();
	chunk->reset();
	chunk->setPosition(position);
	chunk->setGlobal(this, mManager);
	chunk->load();
	
	mAllChunks[position] = chunk;
	
	return chunk;
}



bool Chunk3dContainer::isThere(const ChunkCoordinate &position, Chunk *&chunk) const
{
	ChunkMap::const_iterator it = 
				mAllChunks.find(position);
		
	if (it == mAllChunks.end())
			return false;
		
	chunk = it->second;
	return true;
}

Chunk3dContainer::~Chunk3dContainer()
{
	for (ChunkMap::iterator it = mAllChunks.begin();
		 it != mAllChunks.end(); ++it) {
		mPool.giveBackChunk(it->second);
	}
}
