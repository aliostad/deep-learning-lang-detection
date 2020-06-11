#include "Chunk.h"
#include "blocks/BlockDescriptor.h"
#include "gui/ChunkDrawer.h"
#include "World.h"

Chunk::Chunk(QObject *parent, ChunkPosition position) : QObject(parent), m_state(ChunkState_Idle), b_dirty(true), m_position(position), m_chunkDrawer(NULL)
{
	int size = CHUNK_X_SIZE * CHUNK_Z_SIZE * CHUNK_Y_SIZE;
	p_BlockInfos = new BlockInfo[size];
}

Chunk::~Chunk()
{
	idle();
	delete[] p_BlockInfos;
}

void Chunk::activate()
{
	QWriteLocker locker(&m_rwLock);
	if(m_state != ChunkState_Active) {
		m_chunkDrawer = new ChunkDrawer(this);
		b_dirty = true; // we must redraw the chunk
		m_state = ChunkState_Active;
	}

}

void Chunk::idle()
{
	QWriteLocker locker(&m_rwLock);
	if(m_state != ChunkState_Idle) {
		delete m_chunkDrawer;
		m_state = ChunkState_Idle;
	}
}

int Chunk::altitude(const int x, const int z)
{
	QReadLocker locker(&m_rwLock);
	int highest = 0;
	for(int y = 0; y < CHUNK_HEIGHT; y++)
	{
		if(!block(x, y, z)->descriptor().canPassThrough()) {
			highest = y;
		}
		else { // void
			if(highest != 0) { // If the last block was not void, but this is void, it means that we are on the top
				return highest + 1; // +1 is the size of the cube
			}
		}
	}
	return highest;
}

BlockInfo* Chunk::block(const int x, const int y, const int z)
{
	if(x < 0 || y < 0 || z < 0 || x >= CHUNK_X_SIZE || y >= CHUNK_Y_SIZE || z >= CHUNK_Z_SIZE) {
		return BlockInfo::voidBlock();
	}
	else {
		int ID = y + x * CHUNK_Y_SIZE + z * CHUNK_Y_SIZE * CHUNK_X_SIZE;
		BlockInfo* block = &p_BlockInfos[ID];
		return block;
	}
}

void Chunk::mapToWorld(const int chunkX, const int chunkY, const int chunkZ, int& worldX, int& worldY, int& worldZ) const
{
	worldX = m_position.first * CHUNK_X_SIZE + chunkX;
	worldY = chunkY;
	worldZ = m_position.second * CHUNK_Z_SIZE + chunkZ;
}

void Chunk::makeDirty()
{
	QWriteLocker locker(&m_rwLock);
	b_dirty = true;
}

void Chunk::makeSurroundingChunksDirty() const
{
	world().chunk(ChunkPosition(m_position.first - 1, m_position.second    ))->makeDirty();
	world().chunk(ChunkPosition(m_position.first + 1, m_position.second    ))->makeDirty();
	world().chunk(ChunkPosition(m_position.first    , m_position.second - 1))->makeDirty();
	world().chunk(ChunkPosition(m_position.first    , m_position.second + 1))->makeDirty();
}

void Chunk::render3D()
{
	if(m_state == ChunkState_Active) {
		if(b_dirty) {
			m_chunkDrawer->generateVBO();
			b_dirty = false;
		}
		m_chunkDrawer->render(); // Incredibly fast !
	}
}
