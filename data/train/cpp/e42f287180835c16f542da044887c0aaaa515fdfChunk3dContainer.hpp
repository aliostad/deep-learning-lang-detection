#ifndef CHUNK3DCONTAINER_HPP
#define CHUNK3DCONTAINER_HPP



#define _GLIBCXX_PERMIT_BACKWARD_HASH 0
#include <hash_map>

#include "Chunk.hpp"
#include "ChunkPool.hpp"

class Chunk;

class Chunk3dContainer
{
	friend class ChunkManager;
		
	public:
		Chunk3dContainer();
		
		//test
		void forceRebuild();
		
		Chunk * create(const ChunkCoordinate & position);
		
		// Get Chunk and Test existance at same time
		bool isThere(const ChunkCoordinate & position, Chunk *& chunk) const;
		
		~Chunk3dContainer();
		
	private:
		
		void setGlobal(ChunkManager * manager) {
			mManager = manager;
		}
				
		typedef __gnu_cxx::hash_map<const ChunkCoordinate, 
									Chunk*, 
									HashChunkCoordinate> ChunkMap;
		
		// Chunk map : (ChunkCoordinate) -> (Chunk)
		ChunkMap mAllChunks;
		
		// Memory manager for Chunk
		ChunkPool mPool;
		
		
		ChunkManager * mManager;
		
		
		
		
};

#endif // CHUNK3DCONTAINER_HPP
