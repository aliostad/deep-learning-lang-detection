#include "stdafx.h"
#include "ChunkColumn.h"
#include "Chunk.h"
#include <new>

using namespace vox;

ChunkColumn::ChunkColumn(void) :
	_chunks(nullptr)
{
}


ChunkColumn::~ChunkColumn(void)
{
	if (_chunks != nullptr)
		delete[] _chunks;
}

bool
ChunkColumn::Init(int PosX, int PosZ, unsigned char* data)
{
	const int chunkSizeCube = Chunk::CHUNK_SIZE * Chunk::CHUNK_SIZE * Chunk::CHUNK_SIZE;
	_chunks = new (std::nothrow) Chunk[CHUNK_COUNT];
	if (_chunks == nullptr)
		return false;
	_posX = PosX;
	_posZ = PosZ;
	const int spaceBetweenChunk = Chunk::CHUNK_SIZE * 2 * Chunk::CHUNK_SCALE;
	for (int i = 0; i < CHUNK_COUNT; ++i)
	{
//		if (!_chunks[i].init(_posX * spaceBetweenChunk, i * spaceBetweenChunk, _posZ * spaceBetweenChunk))
//		{
//			Destroy();
//			return false;
//		}
		for (int x = 0; x < Chunk::CHUNK_SIZE; ++x)
		{
			for (int y = 0; y < Chunk::CHUNK_SIZE; ++y)
			{
				for (int z = 0; z < Chunk::CHUNK_SIZE; ++z)
				{
					int id = data[i * chunkSizeCube + x + z * 16 + y * 256];
					_chunks[i].setBlockActive(x, y, z, id);
				}
			}
		}
		if (!_chunks[i].createMesh())
			return false;
	}
	return true;
}

bool
ChunkColumn::InitGL(void)
{
	for (int i = 0; i < CHUNK_COUNT; ++i)
	{
		if (!_chunks[i].initGL())
			return false;
		_chunks[i].bindMesh();
	}
	return true;
}

bool
ChunkColumn::Render(GLint attrCoord3D, GLint attrVertexColor, GLint attrVertexNormal,
					GLint attrUniformModel, Frustum& frustum, GLint attrTexture)
{
	glm::mat4	Model;
	float		chunkScale = (float)Chunk::CHUNK_SCALE;
	for (int i = 0 ; i < CHUNK_COUNT ; ++i)
	{
		glm::vec3	pos;
		_chunks[i].getPosition(pos);
		if (frustum.BoxInFrustum(pos.x, pos.y, pos.z, pos.x + Chunk::CHUNK_SIZE * 2,
								 pos.y + Chunk::CHUNK_SIZE * 2, pos.z + Chunk::CHUNK_SIZE * 2) != Frustum::Outside)
		{
			Model = glm::translate(glm::mat4(), pos) *
				glm::scale(chunkScale, chunkScale, chunkScale);
			glUniformMatrix4fv(attrUniformModel, 1, GL_FALSE, &Model[0][0]);
		//	if (!_chunks[i].Render(attrCoord3D, attrVertexColor, attrVertexNormal, attrTexture))
		//		return false;
		}
	}
	return true;
}

void
ChunkColumn::Destroy(void)
{
}


bool
ChunkColumn::getBlockAt(int chunkKey, int x, int y, int z, int id)
{
	if (chunkKey >= 16)
		return false;
	if (x >= 0 && y >= 0 && z >= 0)
	{
		if (x >= 16)
			x = 15;
		if (z >= 16)
			z = 15;
		_chunks[chunkKey].setBlockActive(x, y, z, id);
		_chunks[chunkKey].createMesh();
		_chunks[chunkKey].bindMesh();
	}
	return true;		
}

int
ChunkColumn::getBlockAt(int x, int y, int z)
{
	int key = y / 16;

	if (key >= 16)
		return -1;
	if (x >= 0 && y >= 0 && z >= 0)
	{
		if (x >= 16)
			x = 15;
		if (z >= 16)
			z = 15;
		y %= 16;
		return _chunks[key].GetBlockID(x, y, z);
	}
	return -1;	
}