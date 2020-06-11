#include "voxel_pch.h"
#include "voxel_ChunkLoader.h"
#include "voxel_ChunkManager.h"
#include "voxel/voxel_Chunk.h"
#include "voxel/voxel_Meshizer.h"
#include "voxel_PoolManager.h"
#include "voxel_VoxelUtils.h"
#include "voxel_OctreeManager.h"
#include "voxel/voxel_ChunkMesh.h"
namespace ld3d
{
	namespace voxel
	{
		ChunkLoader::ChunkLoader(void)
		{
			m_pendingCount = 0;
		}


		ChunkLoader::~ChunkLoader(void)
		{
		}
		bool ChunkLoader::Initialize(ChunkManagerPtr pChunkManager, OctreeManagerPtr pOctreeManager, MeshizerPtr pMeshizer, WorldGenPtr pWorldGen)
		{
			m_pChunkManager		= pChunkManager;
			m_pOctreeManager	= pOctreeManager;
			m_pMeshizer			= pMeshizer;

			m_service.Initialize(*pMeshizer, *pWorldGen);
			return true;
		}
		void ChunkLoader::Release()
		{
			m_service.Release();

		}
		void ChunkLoader::Update()
		{
			m_service.Run();

		}

		bool ChunkLoader::RequestChunk(const ChunkKey& key, const ChunkLoadedHandler& on_loaded)
		{
			bool loaded = false;
			ChunkPtr pChunk = m_pChunkManager->FindChunk(key, loaded);

			if(pChunk != nullptr)
			{
				pChunk->IncRef();

				if(on_loaded)
				{
					on_loaded(key);
				}

				return true;
			}

			if(loaded == true)
			{
				return true;
			}
			m_pendingCount++;
			m_service.GenChunk(key, [=](const ChunkKey& key, const ChunkData& data, const ChunkAdjacency& adj, bool is_empty)
			{
				_on_chunk_gen_complete(key, data, adj, is_empty);

				if(on_loaded)
				{
					on_loaded(key);
				}
				m_pendingCount--;
			});
			
			return true;
		}
		void ChunkLoader::_on_chunk_gen_complete(const ChunkKey& key, const ChunkData& data, const ChunkAdjacency& adj, bool is_empty)
		{
			ChunkPtr pChunk = nullptr;
			if(is_empty == false)
			{
				pChunk = m_pChunkManager->CreateChunk(key, data.GetData());
				pChunk->SetAdjacency(adj);
				pChunk->SetGenerated(true);
			}

			m_pChunkManager->AddChunk(key, pChunk);

			UpdateChunkAdjacency(key);

		}
		

		uint32 ChunkLoader::GetPendingCount() const
		{
			return m_pendingCount;
		}
		
		bool ChunkLoader::RequestChunk(const Coord& center, uint32 radius, uint32 height, const std::function<bool(const ChunkKey&)>& pre_load)
		{
			m_pChunkManager->PickChunk(center, radius, height, [&](const ChunkKey& key)
			{
				Coord c = key.ToChunkOrigin();
				if((c.y + (int32)CHUNK_SIZE) < -16 || (c.y > 128))
				{
					return;
				}

				if(pre_load(key) == true)
				{
					RequestChunk(key, nullptr);
				}
			});

			return true;
		}
		
		void ChunkLoader::UpdateChunkAdjacency(const ChunkKey& key)
		{
			bool loaded = false;
			ChunkPtr pChunk = m_pChunkManager->FindChunk(key, loaded);
			if(loaded == false)
			{
				return;
			}

			Coord this_coord = key.ToChunkCoord();
			m_pChunkManager->PickSurroundingChunks(key, [&](const ChunkKey& adjKey, ChunkPtr pAdj, bool adjLoaded)
			{
				Coord this_coord = key.ToChunkCoord();
				Coord c = adjKey.ToChunkCoord();
				if(adjLoaded == false)
				{
					return;
				}
				if(pChunk != nullptr)
				{
					pChunk->GetAdjacency().UpdateChunkAdjacency(adjKey, pAdj);
					if(pChunk->GetAdjacency().IsComplete())
					{
						RequestMesh(pChunk);
					}
				}
				
				if(pAdj == nullptr)
				{
					return;
				}
				
				pAdj->GetAdjacency().UpdateChunkAdjacency(key, pChunk);
				if(pAdj->GetAdjacency().IsComplete())
				{
					RequestMesh(pAdj);
				}
			});
		}
		
		bool ChunkLoader::RequestUnloadChunk(ChunkPtr pChunk)
		{
			pChunk->DecRef();
			if(pChunk->GetRef() != 0)
			{
				return true;
			}

			m_pOctreeManager->RemoveChunk(pChunk);
			m_pChunkManager->RemoveChunk(pChunk);
			UpdateChunkAdjacency(pChunk->GetKey());
			return true;
		}
		bool ChunkLoader::RequestUnloadChunk(const ChunkKey& key)
		{
			bool loaded = false;
			ChunkPtr pChunk = m_pChunkManager->FindChunk(key, loaded);
			if(loaded == false)
			{
				return true;
			}
			if(pChunk)
			{
				pChunk->DecRef();
				if(pChunk->GetRef() != 0)
				{
					return true;
				}
			}

			m_pOctreeManager->RemoveChunk(pChunk);
			m_pChunkManager->RemoveChunk(key);
			UpdateChunkAdjacency(key);

			return true;
		}

		
		bool ChunkLoader::RequestMesh(ChunkPtr pChunk)
		{
			++m_pendingCount;

			m_service.GenMesh(pChunk->GetKey(), pChunk->GetData(), pChunk->GetAdjacency(), [=](const ChunkKey& key, ChunkMesh* mesh)
			{
				_on_mesh_gen_complete(key, mesh);
				--m_pendingCount;
			});

			return true;
		}
		void ChunkLoader::_on_mesh_gen_complete(const ChunkKey& key, ChunkMesh* mesh)
		{
			bool loaded = false;
			ChunkPtr pChunk = m_pChunkManager->FindChunk(key, loaded);
			if(pChunk == nullptr)
			{
				return;
			}

			
			if(mesh->GetSubsetCount() == 0)
			{
				return;
			}

			if(pChunk->GetMesh() != nullptr && pChunk->GetMesh()->GetSubsetCount() != 0)
			{
				return;
			}


			ChunkMeshPtr pMesh = pool_manager()->AllocChunkMesh();
			pMesh->AllocVertexBuffer(mesh->GetVertexCount());
			pMesh->AllocIndexBuffer(mesh->GetIndexCount());
			memcpy(pMesh->GetVertexBuffer(), mesh->GetVertexBuffer(), sizeof(ChunkMesh::VoxelVertex) * mesh->GetVertexCount());
			memcpy(pMesh->GetIndexBuffer(), mesh->GetIndexBuffer(), sizeof(uint16) * mesh->GetIndexCount());
			for(uint32 i = 0; i < mesh->GetSubsetCount(); ++i)
			{
				ChunkMesh::Subset s = mesh->GetSubset(i);

				uint64 offset = (uint8*)s.vertexBuffer - (uint8*)mesh->GetVertexBuffer();

				s.vertexBuffer = (uint8*)pMesh->GetVertexBuffer() + offset;


				offset = (uint8*)s.indexBuffer - (uint8*)mesh->GetIndexBuffer();
				s.indexBuffer = (uint8*)pMesh->GetIndexBuffer() + offset;

				pMesh->AddSubset(s);
			}

			pChunk->SetMesh(pMesh);

			m_pOctreeManager->AddChunk(pChunk);
		}
	}
}
