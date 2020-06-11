#pragma once
#include "stdafx.h"
#include "Chunk.h"

namespace kg
{
	class ChunkContainer
	{
		std::list<Chunk> m_chunks;//has to be a list because of reference invalidation

	public:
		Chunk& getChunk( const ChunkPosition& position );
		const Chunk& getChunk_const( const ChunkPosition& position )const;//will throw if chunk does not exist
		bool doesChunkExist( const ChunkPosition& position )const;

		std::vector<Chunk*> getAllLoadedChunks();
		std::vector<Chunk*> getAllLoadedOrLoadingChunks();

		void clear();
	};
}