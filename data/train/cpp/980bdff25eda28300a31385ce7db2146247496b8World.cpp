#include "World.h"
#include "ChunkGenerator.h"
#include "PhysicObject.h"
#include "PhysicEngine.h"

#include <QDebug>

World::World(Server* server, const int seed, QObject *parent) : QObject(parent), m_server(server), i_seed(seed)
{
	m_physicEngine = new PhysicEngine(this, this);
	m_chunks = new QHash<ChunkPosition, Chunk*>();
	m_voidChunk = new Chunk(this, ChunkPosition(999999,999999));
}

World::~World()
{
	QHashIterator<ChunkPosition, Chunk*> it(*m_chunks);
	while (it.hasNext()) {
		it.next();
		delete it.value(); // Delete each chunks of the world
	}
	delete m_chunks;
	delete m_voidChunk;
	delete m_physicEngine;
}

const PhysicObject* World::po(const int id) const
{
	return m_physicEngine->po(id);
}

Chunk* World::chunk(const ChunkPosition& position) const
{
	if(isChunkLoaded(position)) // If the chunk is already loaded
	{
		return m_chunks->value(position);
	}
	else // otherwise, we return a void chunk (and we DONT load it)
	{
		return m_voidChunk;
	}
}

Chunk* World::chunk(const BlockPosition& position) const
{
	return chunk(chunkPosition(position.x, position.z));
}

ChunkPosition World::chunkPosition(const int x, const int z) const
{
	int cx, cz;
	// without this check, it would return 0;0 for the chunk at -0.5;-0.3
	// but chunk -0;-0 is the same as 0;0, hence the -1 to have chunk -1;-1
	if(x < 0) {
		cx = x / CHUNK_X_SIZE - 1;
	}
	else {
		cx = x / CHUNK_X_SIZE;
	}
	if(z < 0) {
		cz = z / CHUNK_Z_SIZE - 1;
	}
	else {
		cz = z / CHUNK_Z_SIZE;
	}
	return ChunkPosition(cx, cz);
}

ChunkPosition World::chunkPosition(const BlockPosition& position) const
{
	return chunkPosition(position.x, position.z);
}

bool World::isChunkLoaded(const ChunkPosition& position) const
{
	return m_chunks->contains(position);
}

void World::loadChunk(const ChunkPosition& position)
{
	if(isChunkLoaded(position)) // safety : If the chunk is already loaded
	{
		return;
	}
	else // otherwise, we generate a new fresh one
	{
		Chunk* newChunk = new Chunk(this, position);
		ChunkGenerator* chunkGenerator = new ChunkGenerator(newChunk, i_seed);
		// The generation thread will activate the chunk when finished
		connect(chunkGenerator, SIGNAL(finished()), newChunk, SLOT(activate()));
		// The generation thread will auto-destroy itself when finished
		connect(chunkGenerator, SIGNAL(finished()), chunkGenerator, SLOT(deleteLater()));
		// Start the generation of the chunk
		chunkGenerator->start();
		m_chunks->insert(position, newChunk);
	}
}

void World::unloadChunk(Chunk* chunk)
{
	unloadChunk(m_chunks->key(chunk));
}

void World::unloadChunk(const ChunkPosition& position)
{
	delete m_chunks->value(position);
	m_chunks->remove(position);
}

BlockInfo* World::block(const BlockPosition& bp) const
{
	ChunkPosition chunkPos = chunkPosition(bp);
	int chunkBlockX, chunkBlockZ; // the coordinates of the block relative to the chunk
	if(bp.x < 0) {
		chunkBlockX = bp.x - chunkPos.first * CHUNK_X_SIZE;
	}
	else { // in positives we can use modulo
		chunkBlockX = bp.x % CHUNK_X_SIZE;
	}

	if(bp.z < 0) {
		chunkBlockZ = bp.z - chunkPos.second * CHUNK_Z_SIZE;
	}
	else {
		chunkBlockZ = bp.z % CHUNK_Z_SIZE;
	}

	if(isChunkLoaded(chunkPos)) {
		return chunk(chunkPos)->block(chunkBlockX, bp.y, chunkBlockZ);
	}
	else {
		return BlockInfo::voidBlock();
	}
}

BlockInfo* World::block(const Vector& position)
{
	BlockPosition bp = position.toBlock();// Get the block integer coordinates in the world
	return this->block(bp);
}

int World::altitude(const int x, const int z)
{
	ChunkPosition chunkPos = chunkPosition(x, z);
	int chunkBlockX, chunkBlockZ; // the coordinates of the block relative to the chunk

	if(x < 0) {
		chunkBlockX = x - chunkPos.first * CHUNK_X_SIZE;
	}
	else { // in positives we can use modulo
		chunkBlockX = x % CHUNK_X_SIZE;
	}

	if(z < 0) {
		chunkBlockZ = z - chunkPos.second * CHUNK_Z_SIZE;
	}
	else {

		chunkBlockZ = z % CHUNK_Z_SIZE;
	}
	return chunk(chunkPos)->altitude(chunkBlockX, chunkBlockZ);
}

BlockPosition World::highestBlock(const Vector& position)
{
	BlockPosition blockPosition = position.toBlock();
	blockPosition.y = altitude(blockPosition.x, blockPosition.z);
	return blockPosition;
}

void World::render3D()
{
	QHash<ChunkPosition, Chunk*>::const_iterator it = m_chunks->constBegin();
	QHash<ChunkPosition, Chunk*>::const_iterator endit = m_chunks->constEnd();
	while (it != endit) {
		it.value()->render3D();
		++it;
	}
}
