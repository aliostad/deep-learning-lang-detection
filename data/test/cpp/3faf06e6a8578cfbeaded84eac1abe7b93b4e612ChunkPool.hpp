#ifndef CHUNKPOOL_HPP
#define CHUNKPOOL_HPP


#include <list>
#include <stack>
#include <vector>
#include <queue>

//#include "Chunk.hpp"
class Chunk;
class ChunkManager;


typedef std::stack<Chunk*> ChunkStack;
typedef std::queue<Chunk*> ChunkQueue;
typedef std::vector<Chunk*> ChunkVector;



class ChunkPool
{
	public:
		ChunkPool();
		
		Chunk * getFreeChunk();
		void giveBackChunk(Chunk *chunk);
		
		~ChunkPool();		
		
	private:		
		ChunkStack mFreeChunks;
		ChunkQueue mUsedChunks;
		ChunkVector mPoolChunks;
		
};

#endif // CHUNKPOOL_HPP
