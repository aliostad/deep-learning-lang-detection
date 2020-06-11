#pragma once
#include "Chunk.h"
#include "ChunkManager.h"
#include "TerrainGenerator.h"


class ChunkManager;
class Chunk;
class TerrainGenerator;

class TerrainChunk
{
public:
	TerrainChunk(ChunkManager* mChunkManager);
	~TerrainChunk(void);

	// maximum amount of chunks in height
	static const int TERRAIN_MAX_HEIGHT = 8;

	bool containsChunk(Chunk* chunk);
	void setColumn(std::vector<Chunk*> chunks);
	void generateTerrain(TerrainGenerator* generator);

private:
	ChunkManager* mChunkManager;
	std::vector<Chunk*> chunks;

	int addCount;

	Block* getBlock(int x, int y, int z);
};

