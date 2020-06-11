#include "ChunkCache.hpp"

namespace Antumbra
{
	ChunkCache::ChunkCache(World &world, int minX, int minZ, int maxX, int maxZ)
	{
		m_minX = minX;
		m_minZ = minZ;
		m_maxX = maxX;
		m_maxZ = maxZ;
		m_xChunks = m_maxX - m_minX + 1;
		m_zChunks = m_maxZ - m_minZ + 1;
		m_allLoaded = true;

		for(int z = m_minZ; z <= m_maxZ; z++)
		{
			for(int x = m_minX; x <= m_maxX; x++)
			{
				auto chunk = world.GetChunk(x, z);
				if(!chunk)
				{
					m_allLoaded = false;
				}

				m_chunks.push_back(chunk);
			}
		}
	}

	void ChunkCache::SetBlock(int x, int y, int z, uint8_t id)
	{
		auto chunk = GetChunk(x, z);
		if(chunk)
		{
			int blockX, blockZ;
			GetBlockCoords(x, z, blockX, blockZ);
			chunk->SetBlock(blockX, y, blockZ, id);
		}
	}

	void ChunkCache::SetLight(int x, int y, int z, uint8_t level)
	{
		auto chunk = GetChunk(x, z);
		if(chunk)
		{
			int blockX, blockZ;
			GetBlockCoords(x, z, blockX, blockZ);
			chunk->SetLight(blockX, y, blockZ, level);
		}
	}

	void ChunkCache::SetSkyLight(int x, int y, int z, uint8_t level)
	{
		auto chunk = GetChunk(x, z);
		if(chunk)
		{
			int blockX, blockZ;
			GetBlockCoords(x, z, blockX, blockZ);
			chunk->SetSkyLight(blockX, y, blockZ, level);
		}
	}

	uint8_t ChunkCache::GetBlock(int x, int y, int z) const
	{
		auto chunk = GetChunk(x, z);
		if(chunk && y >= 0 && y < Chunk::Height)
		{
			int blockX, blockZ;
			GetBlockCoords(x, z, blockX, blockZ);
			return chunk->GetBlock(blockX, y, blockZ);
		}

		return 0;
	}

	uint8_t ChunkCache::GetLight(int x, int y, int z) const
	{
		auto chunk = GetChunk(x, z);
		if(chunk && y >= 0 && y < Chunk::Height)
		{
			int blockX, blockZ;
			GetBlockCoords(x, z, blockX, blockZ);
			return chunk->GetLight(blockX, y, blockZ);
		}

		return 15;
	}

	uint8_t ChunkCache::GetSkyLight(int x, int y, int z) const
	{
		auto chunk = GetChunk(x, z);
		if(chunk && y >= 0 && y < Chunk::Height)
		{
			int blockX, blockZ;
			GetBlockCoords(x, z, blockX, blockZ);
			return chunk->GetSkyLight(blockX, y, blockZ);
		}

		return 15;
	}

	Chunk *ChunkCache::GetChunk(int x, int z)
	{
		int chunkX, chunkZ; GetChunkCoords(x, z, chunkX, chunkZ);
		int localX = chunkX - m_minX;
		int localZ = chunkZ - m_minZ;
		assert(chunkX >= m_minX && chunkZ >= m_minZ);
		assert(chunkX <= m_maxX && chunkZ <= m_maxZ);
		return m_chunks[localZ * m_xChunks + localX];
	}

	const Chunk *ChunkCache::GetChunk(int x, int z) const
	{
		int chunkX, chunkZ; GetChunkCoords(x, z, chunkX, chunkZ);
		int localX = chunkX - m_minX;
		int localZ = chunkZ - m_minZ;
		assert(chunkX >= m_minX && chunkZ >= m_minZ);
		assert(chunkX <= m_maxX && chunkZ <= m_maxZ);
		return m_chunks[localZ * m_xChunks + localX];
	}
}