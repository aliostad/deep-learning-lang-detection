#pragma once

#include "minecraft_def.h"

#include "World.h"

#include "cppNBT\src\cppnbt.h"
#include "scottbase/Unknown.h"

#include <vector>
using namespace std;

class ChunkSection;
class Region;
class World;

#define SECTION_HEIGHT 16
#define CHUNK_WIDTH 16
#define CHUNK_HEIGHT 256

typedef enum ChunkMode {
	eAllChunkBorders,
	eVisibleChunkBorders,
	eNoChunkBorders,
} ChunkMode;

typedef struct ChunkLoc {
	ChunkLoc()
		: x(0), z(0) {};

	ChunkLoc(int x, int z)
		: x(x), z(z) {};

	int x;
	int z;
} ChunkLoc;

bool operator < (const ChunkLoc &l, const ChunkLoc &r);

class Chunk : public Unknown
{
public:
    Chunk(const Region *region, const ChunkLocation *chunkLocation); //constructor!
    Chunk(const Chunk &chunk); //copy

	const ChunkLoc				getLoc() const										{ return m_Loc; }

	inline unsigned int	getBlockIdAt(int x, int y, int z) const
	{
		if (m_ChunkMode != eAllChunkBorders)
		{
			if (x < 0)
			{
				ChunkLoc loc(m_Loc.x - 1, m_Loc.z);
				Chunk *pNeighbor = m_pWorld->getChunk(loc);

				if (pNeighbor)
				{
					int blockId = pNeighbor->getBlockIdAt(CHUNK_WIDTH - 1, y, z);
					return blockId;
				}
			}

			if (x >= CHUNK_WIDTH)
			{
				ChunkLoc loc(m_Loc.x + 1, m_Loc.z);
				Chunk *pNeighbor = m_pWorld->getChunk(loc);

				if (pNeighbor)
				{
					int blockId = pNeighbor->getBlockIdAt(0, y, z);
					return blockId;
				}
			}

			if (z < 0)
			{
				ChunkLoc loc(m_Loc.x, m_Loc.z - 1);
				Chunk *pNeighbor = m_pWorld->getChunk(loc);

				if (pNeighbor)
				{
					int blockId = pNeighbor->getBlockIdAt(x, y, CHUNK_WIDTH - 1);
					return blockId;
				}
			}

			if (z >= CHUNK_WIDTH)
			{
				ChunkLoc loc(m_Loc.x, m_Loc.z + 1);
				Chunk *pNeighbor = m_pWorld->getChunk(loc);

				if (pNeighbor)
				{
					int blockId = pNeighbor->getBlockIdAt(x, y, 0);
					return blockId;
				}
			}
		}

		if (x < 0 || x >= CHUNK_WIDTH || z < 0 || z >= CHUNK_WIDTH || y < 0 || y >= CHUNK_HEIGHT)
		{ //not in this chunk
			if (m_ChunkMode == eNoChunkBorders)
			{
				return 1;
			}

			return 0;
		}

		unsigned int offset = y * CHUNK_HEIGHT + z * CHUNK_WIDTH + x;
		return m_Blocks[offset];
	}

	//unknown
    const char                  *getClassName() const;

	void						setWorld(World *world);

protected:
    ~Chunk();

	const unsigned char			*getBlocks() const		{ return &m_Blocks[0]; }
	World						*getWorld() const		{ return m_pWorld; }

	void						setLoc(ChunkLoc loc)	{ m_Loc = loc; }

private:
	World						*m_pWorld;

	ChunkMode					m_ChunkMode;
	ChunkLoc					m_Loc;
	unsigned char				m_Blocks[CHUNK_WIDTH * CHUNK_WIDTH * CHUNK_HEIGHT];

    void						go(const Region *region, const ChunkLocation *chunkLocation);
};