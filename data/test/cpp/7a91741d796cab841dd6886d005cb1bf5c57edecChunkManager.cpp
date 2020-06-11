
#include "ChunkManager.h"

#include "VoxelEngine.h"

#include <iostream>

using namespace engine;
using namespace sgl;

ChunkManager::ChunkManager(int x, int y, int z, const char *atlasName) : ChunkManager(x, y, z, 16, 1, atlasName)
{
}

ChunkManager::ChunkManager(int x, int y, int z, int blocksPerChunk, float blockSize, const char *atlasName) :
	_blockX(x),
	_blockY(y),
	_blockZ(z),
	_blocksPerChunk(blocksPerChunk),
	_blockSize(blockSize),
	_rebuildsPerFrame(5),
	_atlasName(atlasName),
	_renderDebug(false),
	_updateBoundingVolume(true)
{
	allocateChunks(blocksPerChunk, blockSize);

	_worldTransform.toTranslation(0, 0, 0);
}

void ChunkManager::update()
{
	if (_updateBoundingVolume)
	{
		updateChunkVolumes();
		_updateBoundingVolume = false;
	}

	rebuildChunks();
}

void ChunkManager::updateVisiblityList(Frustum& frustum)
{
	// clear the current chunks
	_chunkRenderSet.clear();

	int i, j, k;

	for (i = 0; i < _size; ++i)
	{
		for (j = 0; j < _size; ++j)
		{
			for (k = 0; k < _size; ++k)
			{
				Chunk& chunk = getChunk(i, j, k);

				Sphere& bounds = chunk.getBounds();

				Frustum::Side side = frustum.checkSphere(bounds);

				if (side == Frustum::Side::INSIDE || side == Frustum::Side::INTERSECT)
				{
					if (chunk.isSetup())
					{
						_chunkRenderSet.insert(&chunk);
					}
					else
					{
						_chunkRebuildSet.insert(&chunk);
					}
				}
			}
		}
	}
}

void ChunkManager::translate(float x, float y, float z)
{
	_worldTransform.translate(x, y, z);
	_updateBoundingVolume = true;
}

void ChunkManager::rotate(float x, float y, float z)
{
	_worldTransform.rotate(x, y, z);
	_updateBoundingVolume = true;
}

void ChunkManager::scale(float s)
{
	_worldTransform.scale(s);
	_updateBoundingVolume = true;
}

void ChunkManager::render()
{
	ChunkSet::iterator iter;
	for (iter = _chunkRenderSet.begin(); iter != _chunkRenderSet.end(); ++iter)
	{
		Chunk* chunk = (*iter);
		
		if (chunk->shouldRender())
		{
			chunk->render();
		}
	}
}

void ChunkManager::updateChunkVolumes()
{
	int i, j, k;
	for (i = 0; i < _size; ++i)
		for (j = 0; j < _size; ++j)
			for (k = 0; k < _size; ++k)
			{
				Chunk& chunk = getChunk(i, j, k);
				chunk.calculateBounds(_worldTransform);
			}

	_updateBoundingVolume = false;
}

Block ChunkManager::getBlockFromWorldPosition(const sgl::Vector3& p)
{
	return getBlockFromWorldPosition(p.x, p.y, p.z);
}

Block ChunkManager::getBlockFromWorldPosition(float x, float y, float z)
{
	float blockRenderSize = _blockSize * 2;

	int blockX = (int)(x / blockRenderSize);
	int blockY = (int)(y / blockRenderSize);
	int blockZ = (int)(z / blockRenderSize);

	return getBlock(blockX, blockY, blockZ);
}

Chunk& ChunkManager::getChunkFromWorldPosition(const sgl::Vector3& pos)
{
	return getChunkFromWorldPosition(pos.x, pos.y, pos.z);
}

Chunk& ChunkManager::getChunkFromWorldPosition(float x, float y, float z)
{
	// world space size of a chunk
	float chunkRenderSize = (float)(_blocksPerChunk * _blockSize * 2);

	// get the x,y,z indices of the chunk at given location 

	int chunkX = (int)(x / chunkRenderSize);
	int chunkY = (int)(y / chunkRenderSize);
	int chunkZ = (int)(z / chunkRenderSize);

	//
	return getChunk(chunkX, chunkY, chunkZ);
}

Block ChunkManager::getBlock(int x, int y, int z)
{
	int chunkX = x / _blocksPerChunk;
	int chunkY = y / _blocksPerChunk;
	int chunkZ = z / _blocksPerChunk;

	int blockX = x % _blocksPerChunk;
	int blockY = y % _blocksPerChunk;
	int blockZ = z % _blocksPerChunk;

	Chunk& chunk = getChunk(chunkX, chunkY, chunkZ);

	return *chunk.getBlock(blockX, blockY, blockZ);
}

void ChunkManager::setBlock(int x, int y, int z, int t)
{
	int chunkX = x / _blocksPerChunk;
	int chunkY = y / _blocksPerChunk;
	int chunkZ = z / _blocksPerChunk;

	int blockX = x % _blocksPerChunk;
	int blockY = y % _blocksPerChunk;
	int blockZ = z % _blocksPerChunk;

	Chunk& chunk = getChunk(chunkX, chunkY, chunkZ);
	chunk.setBlock(blockX, blockY, blockZ, t);
}

void ChunkManager::setLightSource(int x, int y, int z, int r, int g, int b)
{
	int chunkX = x / _blocksPerChunk;
	int chunkY = y / _blocksPerChunk;
	int chunkZ = z / _blocksPerChunk;

	int blockX = x % _blocksPerChunk;
	int blockY = y % _blocksPerChunk;
	int blockZ = z % _blocksPerChunk;

	Chunk& chunk = getChunk(chunkX, chunkY, chunkZ);
	chunk.setLightSource(blockX, blockY, blockZ, r, g, b);
}

void ChunkManager::removeLight(int x, int y, int z)
{
	int chunkX = x / _blocksPerChunk;
	int chunkY = y / _blocksPerChunk;
	int chunkZ = z / _blocksPerChunk;

	int blockX = x % _blocksPerChunk;
	int blockY = y % _blocksPerChunk;
	int blockZ = z % _blocksPerChunk;

	Chunk& chunk = getChunk(chunkX, chunkY, chunkZ);
	chunk.removeLight(blockX, blockY, blockZ);
}

Chunk& ChunkManager::getChunk(int x, int y, int z)
{
	if (x < 0) x = 0;
	if (y < 0) y = 0;
	if (z < 0) z = 0;

	Chunk& chunk = *(_chunks[(x * _size) + (y * _size * _size) + z]);

	if (!chunk.hasLocation())
	{
		chunk.setLocation(x, y, z);
		chunk.calculateBounds(_worldTransform);
		setChunkNeighbors(chunk);
		chunk.setUpdateCallback(std::bind(&ChunkManager::updateCallback, this, std::placeholders::_1));
	}

	return chunk;
}

void ChunkManager::rebuildChunks()
{
	// nothing to rebuild
	if (_chunkRebuildSet.size() == 0) return;

	int rebuiltCount = 0;

	ChunkList rebuilt;

	ChunkSet::iterator iter;
	for (iter = _chunkRebuildSet.begin(); rebuiltCount < _rebuildsPerFrame && iter != _chunkRebuildSet.end(); ++iter)
	{
		// build the chunk
		Chunk* chunk = (*iter);
		chunk->build();

		// set it to be removed later
		rebuilt.push_back(chunk);

		// add to the render list
		_chunkRenderSet.insert(chunk);

		//
		rebuiltCount++;
	}

	// remove rebuilt chunks
	ChunkList::iterator rebuiltIter;
	for (rebuiltIter = rebuilt.begin(); rebuiltIter != rebuilt.end(); ++rebuiltIter)
	{
		_chunkRebuildSet.erase(*rebuiltIter);
	}
}

void ChunkManager::updateCallback(Chunk* chunk)
{
	_chunkRebuildSet.insert(chunk);
}

int ChunkManager::getBlockX() const
{
	return _blockX;
}

int ChunkManager::getBlockY() const
{
	return _blockY;
}

int ChunkManager::getBlockZ() const
{
	return _blockZ;
}

sgl::Matrix4& ChunkManager::getWorldTransform()
{
	return _worldTransform;
}

void ChunkManager::setAtlasName(const std::string& name)
{
	_atlasName = name;
}

std::string ChunkManager::getAtlasName()
{
	return _atlasName;
}

void ChunkManager::setRenderDebug(bool d)
{
	_renderDebug = d;
}

bool ChunkManager::boundingVolumeOutOfDate()
{
	return _updateBoundingVolume;
}

void ChunkManager::allocateChunks(int chunkSize, float blockSize)
{
	int xSize = _blockX / chunkSize;
	int ySize = _blockY / chunkSize;
	int zSize = _blockZ / chunkSize;

	if (xSize >= ySize && xSize >= zSize) _size = xSize;
	if (ySize >= xSize && ySize >= zSize) _size = ySize;
	if (zSize >= ySize && zSize >= xSize) _size = zSize;

	int chunksToAllocate = _size * _size * _size;

	int i;
	for (i = 0; i < chunksToAllocate; ++i)
	{
		Chunk* chunk = new Chunk(chunkSize, blockSize);
		chunk->setAtlasName(_atlasName);

		_chunks.push_back(chunk);
	}
}

void ChunkManager::setChunkNeighbors(Chunk& chunk)
{
	Vector3 loc = chunk.getLocation();
	int x = (int)loc.x;
	int y = (int)loc.y;
	int z = (int)loc.z;

	if (x - 1 >= 0)
		chunk.left   = &getChunk(x - 1, y, z);
	if (x + 1 < _size)
		chunk.right  = &getChunk(x + 1, y, z);
	if (y + 1 < _size)
		chunk.top    = &getChunk(x, y + 1, z);
	if (y - 1 >= 0)
		chunk.bottom = &getChunk(x, y - 1, z);
	if (z - 1 >= 0)
		chunk.near   = &getChunk(x, y, z - 1);
	if (z + 1 < _size)
		chunk.far    = &getChunk(x, y, z + 1);
}

ChunkManager::~ChunkManager()
{
	ChunkList::iterator iter;
	for (iter = _chunks.begin(); iter != _chunks.end(); ++iter)
	{
		delete *iter;
	}
}
