#include "World.h"
#include "Block.h"

World::World()
{
}


World::~World()
{
}

void World::SetChunk(int x, int y, int z, Chunk chunk)
{
	chunks[Chunk::GetHashCode(x, y, z)] = chunk;
}

Chunk* World::GetChunk(int x, int y, int z)
{
	int key = Chunk::GetHashCode(x, y, z);

	if (chunks.count(key)) 
	{ 
		return &chunks[key];
	}
	return NULL;
}

void World::SetBlock(int x, int y, int z, Block block)
{
	Chunk *chunk = GetChunk(x, y, z);
	if (chunk != NULL) {
		chunk->SetBock(x, y, z, block);
	}
}

void World::OnRender(Draw* draw, int center_chunk_x, int center_chunk_y, int center_chunk_z) {
	Chunk *chunk = GetChunk(center_chunk_x, center_chunk_y, center_chunk_z);
	if (chunk != NULL) {
		chunk->OnRender(draw, center_chunk_x, center_chunk_y, center_chunk_z);
	}
}