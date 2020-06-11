#pragma once
#include "voxel/voxel_ChunkKey.h"


namespace ld3d
{
	namespace voxel
	{
		class ChunkCache
		{
		public:
			ChunkCache(ChunkLoaderPtr pLoader);
			virtual ~ChunkCache(void);

			void													AddChunk(const ChunkKey& key);
			void													Release();
			bool													Initialize(ChunkLoaderPtr pLoader, uint32 size);
			void													Update();

			void													Flush();
			bool													InCache(const ChunkKey& key);
		private:

			typedef std::list<ChunkKey, 
				std_allocator_adapter<ChunkKey>>					ChunkList;

			ChunkList												m_chunks;

			typedef std::unordered_map<uint64, 
				ChunkList::iterator, 
				std::hash<uint64>, 
				std::equal_to<uint64>,
				std_allocator_adapter<std::pair<uint64, 
					ChunkList::iterator>>>							ChunkMap;

			ChunkMap												m_chunkMap;

			uint32													m_cacheSize;
			ChunkLoaderPtr											m_pLoader;
		};
	}
}
