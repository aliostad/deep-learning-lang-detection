#include "Chunk.h"
#include "World.h"
#include "WorldConfig.h"

#include "../Terrain/TerrainGenerator.h"
#include "../Utils/MathHelper.h"
#include "../Utils/VertexBuilder.h"

#include <string.h>

Chunk::Chunk(World* world,int x,int y,int z,int width,int height)
{
	_world = world;

	_chunkX = x;
	_chunkY = y;
	_chunkZ = z;

	_chunkWidth = width;
	_chunkHeight = height;

	_chunkWidth2 = _chunkWidth * _chunkHeight;

	_aabb.min.set(x,y,z);
	_aabb.max.set(x + width,y + height,z + width);

	_dirty = true;
	_cached = false;
	_fresh = true;
	_processing = false;
	_needSave = false;

	_chunkId = MathHelper::Cantorize(x,y,z);
	_distanceFromPlayer = 0.0f;

	_blocks = 0;
}

Chunk::~Chunk()
{
	if (_blocks != 0)
		delete [] _blocks;

	_opaqueVBO.Delete();
	_transparentVBO.Delete();
}

void Chunk::RemoveBlocks()
{
	delete [] _blocks;
	_blocks = 0;
}

void Chunk::Generate()
{
	if(_fresh)
	{
		if (_blocks == 0)
			_initData();

		//TerrainGenerator::CreateFlatTerrain(this);
		TerrainGenerator::Instace()->GenerateChunk(this);

		//here should be something like chunkprovidermanager
		//that have abstract chunkprovider

		_fresh = false;
	}
}

void Chunk::BuildMesh()
{
	if(!_fresh && _dirty)
	{
		if (_blocks == 0)
			return;	

		VertexBuilder::Instance()->BuildChunk(this);
		VertexBuilder::Instance()->BuildTransparentChunk(this);

		_dirty = false;
	}
}

void Chunk::BuildVBO()
{
	_opaqueVBO.Delete();
	_opaqueVBO.Build();

	_transparentVBO.Delete();
	_transparentVBO.Build();
}

void Chunk::ResetVBO()
{
	_opaqueVBO.Reset();
	_transparentVBO.Reset();
}

void Chunk::Draw(bool state)
{
	if (state)
	{
		_opaqueVBO.Draw();
	}else
	{
		_transparentVBO.Draw();
	}	
}

unsigned char Chunk::GetBlock(int x,int y,int z)
{
	if (_blocks == 0)
		return 0;

	x -= _chunkX;
	y -= _chunkY;
	z -= _chunkZ;

	if (x < 0 || y < 0 || z < 0 || (x + y * _chunkWidth + z * _chunkWidth2) >= 4096)
	{
		x = x;
	}

	return _blocks[x + y * _chunkWidth + z * _chunkWidth2];
}

void Chunk::SetBlock(int x,int y,int z,unsigned char blockValue)
{
	x -= _chunkX;
	y -= _chunkY;
	z -= _chunkZ;

	if (x < 0 || y < 0 || z < 0 || (x + y * _chunkWidth + z * _chunkWidth2) >= 4096)
	{
		x = x;
	}

	_blocks[x + y * _chunkWidth + z * _chunkWidth2] = blockValue;
}

bool Chunk::IsProcessing()
{
	return _processing;
}

void Chunk::SetProcessing(bool state)
{
	_processing = state;
}

bool Chunk::IsBlockTransparent(int x,int y,int z)
{
	int xx = x - _chunkX;
	int yy = y - _chunkY;
	int zz = z - _chunkZ;

	if (xx < 0 || xx >= _chunkWidth || zz < 0 || zz >= _chunkWidth || yy < 0 || yy >= _chunkHeight)
	{
		return _world->IsBlockTransparent(x,y,z);
	}

	if (y < WorldConfig::WorldMinY || y >= WorldConfig::WorldMaxY)
	{
		return true;
	}
	
	return _world->_blocks[_blocks[xx + yy * _chunkWidth + zz * _chunkWidth2]]->IsTransparent();
}

bool Chunk::IsBlockVisible(int x,int y,int z)
{
	int xx = x - _chunkX;
	int yy = y - _chunkY;
	int zz = z - _chunkZ;

	if (xx < 0 || xx >= _chunkWidth || zz < 0 || zz >= _chunkWidth || yy < 0 || yy >= _chunkHeight)
	{
		return _world->IsBlockVisible(x,y,z);
	}

	if (y < WorldConfig::WorldMinY || y >= WorldConfig::WorldMaxY)
	{
		return false;
	}

	return _world->_blocks[_blocks[xx + yy * _chunkWidth + zz * _chunkWidth2]]->IsVisible();
}

bool Chunk::IsBlockSpecial(int x,int y,int z)
{
	int xx = x - _chunkX;
	int yy = y - _chunkY;
	int zz = z - _chunkZ;

	if (xx < 0 || xx >= _chunkWidth || zz < 0 || zz >= _chunkWidth || yy < 0 || yy >= _chunkHeight)
	{
		return _world->IsBlockSpecial(x,y,z);
	}

	if (y < WorldConfig::WorldMinY || y >= WorldConfig::WorldMaxY)
	{
		return false;
	}

	return _world->_blocks[_blocks[xx + yy * _chunkWidth + zz * _chunkWidth2]]->IsSpecial();
}

bool Chunk::IsBlockSingle(int x,int y,int z)
{
	int xx = x - _chunkX;
	int yy = y - _chunkY;
	int zz = z - _chunkZ;

	if (xx < 0 || xx >= _chunkWidth || zz < 0 || zz >= _chunkWidth || yy < 0 || yy >= _chunkHeight)
	{
		return _world->IsBlockSingle(x,y,z);
	}

	if (y < WorldConfig::WorldMinY || y >= WorldConfig::WorldMaxY)
	{
		return false;
	}

	return _world->_blocks[_blocks[xx + yy * _chunkWidth + zz * _chunkWidth2]]->IsSingle();
}

void Chunk::_initData()
{
	_blocks = new unsigned char[_chunkWidth * _chunkHeight * _chunkWidth];
	memset(_blocks, 0, sizeof(unsigned char) * _chunkWidth * _chunkHeight * _chunkWidth);
}