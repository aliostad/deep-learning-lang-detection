#pragma once

#include "voxel_ChunkGenService.h"
#include "voxel/voxel_Bound.h"
namespace ld3d
{
	namespace voxel
	{
		class ChunkLoader
		{
		public:

			typedef std::function<void(const ChunkKey&)>			ChunkLoadedHandler;

			ChunkLoader(void);
			virtual ~ChunkLoader(void);

			bool													Initialize(ChunkManagerPtr pChunkManager, OctreeManagerPtr pOctreeManager, MeshizerPtr pMeshizer, WorldGenPtr pWorldGen);
			void													Release();
			void													Update();

			uint32													GetPendingCount() const;

			bool													RequestChunk(const Coord& center, uint32 radius, uint32 height, const std::function<bool(const ChunkKey&)>& pre_load);
			bool													RequestChunk(const ChunkKey& key, const ChunkLoadedHandler& on_loaded);
			bool													RequestUnloadChunk(const ChunkKey& key);
			bool													RequestUnloadChunk(ChunkPtr pChunk);
			bool													RequestMesh(ChunkPtr pChunk);
			
		private:
			void													_on_mesh_gen_complete(const ChunkKey& key, ChunkMesh* mesh);
			void													_on_chunk_gen_complete(const ChunkKey& key, const ChunkData& data, const ChunkAdjacency& adj, bool is_empty);

			void													UpdateChunkAdjacency(const ChunkKey& key);
		private:
			ChunkManagerPtr											m_pChunkManager;
			OctreeManagerPtr										m_pOctreeManager;
			MeshizerPtr												m_pMeshizer;

			int32													m_pendingCount;
			ChunkGenService											m_service;
		};
	}
}