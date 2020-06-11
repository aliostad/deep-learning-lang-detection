#include "ChunkHeightMap.h"
#include "../Utils/MathHelper.h"

ChunkHeightMap::ChunkHeightMap(int posX,int posZ,int chunkWidth)
{
	_chunkX = posX;
	_chunkZ = posZ;

	_chunkWidth = chunkWidth;
	_chunkID = MathHelper::Cantorize(_chunkX,_chunkZ);

	heightmap = new unsigned char[chunkWidth * chunkWidth];
	humidity = new unsigned char[chunkWidth * chunkWidth];
	temps = new unsigned char[chunkWidth * chunkWidth];
}

ChunkHeightMap::~ChunkHeightMap()
{
	delete []heightmap;
	delete []humidity;
	delete []temps;
};

unsigned char &ChunkHeightMap::GetTemp(int x,int z)
{
	x -= _chunkX;
	z -= _chunkZ;

	return temps[x + z * _chunkWidth];
}
unsigned char &ChunkHeightMap::GetHumidity(int x,int z)
{
	x -= _chunkX;
	z -= _chunkZ;

	return humidity[x + z * _chunkWidth];
}
unsigned char &ChunkHeightMap::GetHeightMap(int x,int z)
{
	x -= _chunkX;
	z -= _chunkZ;

	return heightmap[x + z * _chunkWidth];
}