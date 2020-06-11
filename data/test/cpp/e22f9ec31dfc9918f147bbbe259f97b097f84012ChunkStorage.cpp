#include "stdafx.h"

#include "game/types.h"
#include "game/world/WorldParams.h"
#include "game/world/WorldRegion.h"
#include "game/world/ChunkStorage.h"
#include "game/world/ChunkPillar.h"
#include "terrain/TerrainGenerator.h"

namespace GameWorld {

ChunkStorage::ChunkStorage(World& level) :
	mLevel(level), mTerraGen(0)
{
	mRegionMap.fill(static_cast<WorldRegion*>(0));
	
	mTerraGen = new TerrainGenerator(mLevel);
}


ChunkStorage::~ChunkStorage()
{
	if (mTerraGen) {
		delete mTerraGen;
	}
}


void ChunkStorage::shutdown()
{
	for (auto regionIt = mRegionMap.begin(); regionIt != mRegionMap.end(); ++regionIt) {
		if (*regionIt != 0) {
			(*regionIt)->saveToDisk();
		}
	}
}

Chunk* ChunkStorage::getChunkAbs(wCoord x, wCoord y, wCoord z)
{
	return getPillarAbs(x, z).getChunkAbs(y);
}

ChunkPillar& ChunkStorage::getPillarAbs(wCoord x, wCoord z)
{
	return getRegion(getChunkCoordXZ(x), getChunkCoordXZ(z)).getPillar(getChunkIndexXZ(x), getChunkIndexXZ(z));
}

Chunk* ChunkStorage::getChunkLocal(wCoord x, wCoord y, wCoord z)
{
	return getPillarLocal(x, z).getChunkLocal(getChunkIndexYLocal(y));
}

ChunkPillar& ChunkStorage::getPillarLocal(wCoord x, wCoord z)
{
	return getRegion(x, z).getPillar(getChunkIndexXZLocal(x), getChunkIndexXZLocal(z));
}

WorldRegion& ChunkStorage::getRegion(wCoord x, wCoord z)
{
	x = getRegionCoord(x);
	z = getRegionCoord(z);
	size_t index = getRegionIndex(x, z);

	WorldRegion* curRegion = mRegionMap[index];
	if (curRegion == 0 || !curRegion->checkCoords(x, z)) {
		if (curRegion != 0) {
			delete curRegion;
		}
		curRegion = new WorldRegion(mLevel, *this, x, z);
		mRegionMap[index] = curRegion;
	}

	return *curRegion;
}

void ChunkStorage::updateChunkLocal(wCoord x, wCoord y, wCoord z)
{
	Chunk* curChunk = getChunkLocal(x, y, z);
	curChunk->update(true);
}

void ChunkStorage::updateChunkAbs(wCoord x, wCoord y, wCoord z)
{
	Chunk* curChunk = getChunkAbs(x, y, z);
	curChunk->update(true);
}

void ChunkStorage::cubeModifiedAbs(wCoord x, wCoord y, wCoord z)
{
	updateChunkAbs(x, y, z);
	
	if (getCubeIndexXZ(x) == ChunkSizeX - 1) updateChunkAbs(x + ChunkSizeX, y             , z             );
	if (getCubeIndexXZ(x) == 0)				 updateChunkAbs(x - ChunkSizeX, y             , z             );
	if (getCubeIndexY(y)  == ChunkSizeY - 1) updateChunkAbs(x             , y + ChunkSizeY, z             );
	if (getCubeIndexY(y)  == 0)				 updateChunkAbs(x             , y - ChunkSizeY, z             );
	if (getCubeIndexXZ(z) == ChunkSizeZ - 1) updateChunkAbs(x             , y             , z + ChunkSizeZ);
	if (getCubeIndexXZ(z) == 0)				 updateChunkAbs(x             , y             , z - ChunkSizeZ);
}

};
