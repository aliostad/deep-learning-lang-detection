#include "GameWorld.h"

#include <cassert>

#include "TileFileParser.h"
#include "WorldGenerator.h"

void GameWorld::Init(IWorldGenerator* generator)
{
	this->generator.reset(generator);

	for (int x = 0; x < WorldSize; ++x)
	for (int y = 0; y < WorldSize; ++y)
		isChunkLoaded[y][x] = false;

	TileFileParser fileParser(this);
	fileParser.LoadFile(L"Resources\\Data\\Tiles.json");
}

const Tile& GameWorld::GetTile(int layer, int x, int y) const
{
	const WorldChunk& chunk = GetChunk(x / WorldChunk::ChunkSize, y / WorldChunk::ChunkSize);
	
	return chunk.GetTile(layer, x % WorldChunk::ChunkSize, y % WorldChunk::ChunkSize);
}

const WorldChunk& GameWorld::GetChunk(int x, int y) const
{
	x = (x + 40) % 40;
	y = (y + 40) % 40;
	WorldChunk& chunk = chunks[y][x];
	if (chunk.IsInitialized())
		return chunk;

	generator->GenerateChunk(this, x, y, &chunk);

	return chunk;
}

void GameWorld::SetChunk(int x, int y, const WorldChunk& chunk)
{
	x = (x + 40) % 40;
	y = (y + 40) % 40;
	chunks[y][x] = chunk;
}

bool GameWorld::IsChunkInitialized(int x, int y) const
{
	x = (x + 40) % 40;
	y = (y + 40) % 40;
	return chunks[y][x].IsInitialized();
}

const Tile* GameWorld::GetTileList() const
{
	return tileList;
}

void GameWorld::LoadChunk(int x, int y)
{
	x = (x + 40) % 40;
	y = (y + 40) % 40;
	if (!isChunkLoaded[y][x])
		generator->LoadChunk(this, x, y);

	isChunkLoaded[y][x] = true;
}

void GameWorld::UnloadChunk(int x, int y)
{
	x = (x + 40) % 40;
	y = (y + 40) % 40;
	if (isChunkLoaded[y][x])
		generator->UnloadChunk(this, x, y);

	isChunkLoaded[y][x] = false;
}

bool GameWorld::IsChunkLoaded(int x, int y) const
{
	x = (x + 40) % 40;
	y = (y + 40) % 40;
	return isChunkLoaded[y][x];
}

WorldChunk::WorldChunk() : initialized(false), layerCount(0)
{ }

void WorldChunk::SetInitialized()
{
	initialized = true;
}

bool WorldChunk::IsInitialized() const
{
	return initialized;
}

const Tile& WorldChunk::GetTile(int layer, int x, int y) const
{
	return *tiles[layer][y][x];
}

void WorldChunk::SetTile(int layer, int x, int y, const Tile& tile)
{
	if (tile.ID < 0 || tile.ID > 255)
		DebugBreak();

	assert(layer < MaxLayerCount);
	tiles[layer][y][x] = &tile;

	if (layer >= layerCount)
		layerCount = layer + 1;
}

int WorldChunk::GetLayerCount() const
{
	return layerCount;
}

size_t GameLocationHash::operator ()(const Point& value) const
{
	return (value.x * WorldChunk::ChunkSize * 40) + value.y;
}