#pragma once

#include "VoxelChunk.h"

#include <glm\glm.hpp>
#include <unordered_map>
#include <unordered_set>
#include <assert.h>
#include <memory>

#include "../Engine/Utils/Comparables.h"

class PropertyManager;

class ChunkManager
{
public:
	typedef std::unordered_map<const glm::ivec3, std::unique_ptr<VoxelChunk>, IVec3Hash, IVec3Equality> ChunkMap;

	ChunkManager(PropertyManager& propertyManager) 
		: m_propertyManager(propertyManager)
	{};
	ChunkManager(const ChunkManager& copy) = delete;
	~ChunkManager() {};

	std::unique_ptr<VoxelChunk>& getChunk(const glm::ivec3& pos);
	void unloadChunk(const glm::ivec3& chunkPos);
	const ChunkMap& getLoadedChunkMap() const { return m_loadedChunks; };

	bool isChunkGenerated(int chunkX, int chunkZ) const;
	void setChunkGenerated(int chunkX, int chunkZ, bool isGenerated = true);

private:
	std::unique_ptr<VoxelChunk>& loadChunk(const glm::ivec3& pos);

	struct ChunkPos
	{
		ChunkPos(int x, int y) : x(x), y(y) {};
		int x, y;
	};

	struct ChunkPosEq
	{
		bool operator()(const ChunkPos& lhs, const ChunkPos& rhs)
		{
			return lhs.x == rhs.x && lhs.y == rhs.y;
		}
	};

	struct ChunkPosHash
	{
		size_t operator()(const ChunkPos& pos)
		{
			return pos.x * pos.y + (pos.x ^ pos.y);
		}
	};

	std::unordered_set<ChunkPos, ChunkPosHash, ChunkPosEq> m_generatedChunkSet;
	ChunkMap m_loadedChunks;
	PropertyManager& m_propertyManager;
};