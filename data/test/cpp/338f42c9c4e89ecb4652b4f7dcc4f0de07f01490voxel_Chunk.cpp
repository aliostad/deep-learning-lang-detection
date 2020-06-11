#include "voxel_pch.h"
#include "voxel/voxel_Chunk.h"
#include "voxel/voxel_ChunkMesh.h"


namespace ld3d
{
	namespace voxel
	{
		Chunk::Chunk(ChunkManagerPtr pChunkManager, const ChunkKey& key, const ChunkData& data) : m_adjacency(key), m_data(data)
		{
			m_pChunkManager = pChunkManager;
			m_key = key;
			
			m_stateBits = 0;
			m_counter = 0;
			m_userData = nullptr;

			SetGenerated(true);
		}


		Chunk::~Chunk(void)
		{
			if(m_pMesh)
			{
				m_pMesh->Release();
				m_pMesh.reset();
			}
		}
		const ChunkKey& Chunk::GetKey() const
		{
			return m_key;
		}
		void Chunk::SetKey(const ChunkKey& key)
		{
			m_key = key;
		}
		void Chunk::Update()
		{
		}
		bool Chunk::IsDirty() const
		{
			return utils_get_bit(m_stateBits, state_dirty);
		}
		void Chunk::SetDirty(bool dirty)
		{
			utils_set_bit(m_stateBits, state_dirty, dirty);
		}
		void Chunk::SetData(const ChunkData& data)
		{
			m_data = data;
		}
		
		ChunkData& Chunk::GetData()
		{
			return m_data;
		}
		void Chunk::SetUserData(void* pData)
		{
			m_userData = pData;
		}
		void* Chunk::GetUserData()
		{
			return m_userData;
		}
		ChunkManagerPtr Chunk::GetChunkManager()
		{
			return m_pChunkManager;
		}
		ChunkMeshPtr Chunk::GetMesh()
		{
			return m_pMesh;
		}
		void Chunk::SetMesh(ChunkMeshPtr pMesh)
		{
			m_pMesh = pMesh;
		}

		ChunkAdjacency&	Chunk::GetAdjacency()
		{
			return m_adjacency;
		}
		void Chunk::SetAdjacency(const ChunkAdjacency& adj)
		{
			m_adjacency = adj;
		}
		void Chunk::SetGenerated(bool val)
		{
			utils_set_bit(m_stateBits, state_generated, val);
		}
		bool Chunk::IsGenerated() const
		{
			return utils_get_bit(m_stateBits, state_generated);
		}
	}
}
