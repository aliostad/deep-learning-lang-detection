#include "WorldGenerator.h"


WorldGenerator::WorldGenerator(void)
{
}


WorldGenerator::~WorldGenerator(void)
{
}

void WorldGenerator::GenerateChunkData(Chunk& chunk)
{
	
	
	float height[Chunk::WIDTH*Chunk::WIDTH];
	for (int i = 0; i<Chunk::WIDTH*Chunk::WIDTH; i++) height[i] = 3.0f;
	for (int noiseScale = 1, j = 0;  noiseScale < 256, j<8; noiseScale*=2, j++) //j = log_2(noiseScale)
	{
		glm::vec2 vecs0 = getVector(SEED, (chunk.chunkCoord.x >> j), (chunk.chunkCoord.y >> j));
		glm::vec2 vecs1 = getVector(SEED, (chunk.chunkCoord.x >> j), (chunk.chunkCoord.y >> j) + 1);
		glm::vec2 vecs2 = getVector(SEED, (chunk.chunkCoord.x >> j) + 1, (chunk.chunkCoord.y >> j));
		glm::vec2 vecs3 = getVector(SEED, (chunk.chunkCoord.x >> j) + 1, (chunk.chunkCoord.y >> j) + 1);

		for (int x = 0;x<Chunk::WIDTH;x++)
		{
			for (int y= 0; y<Chunk::WIDTH;y++)
			{
				float posX = (float)(Chunk::WIDTH * (positiveMod(chunk.chunkCoord.x , noiseScale)) + x)/Chunk::WIDTH/noiseScale;
				float posY = (float)(Chunk::WIDTH * (positiveMod(chunk.chunkCoord.y , noiseScale)) + y)/Chunk::WIDTH/noiseScale;
				float dots0 = posX * vecs0.x + posY * vecs0.y;
				float dots1 = posX * vecs1.x + (1.0f - posY) * vecs1.y;
				float dots2 = (1.0f - posX) * vecs2.x + posY * vecs2.y;
				float dots3 = (1.0f - posX) * vecs3.x + (1.0f - posY) * vecs3.y;
				float lerp1 = dots0 - (dots0 - dots1) * posY;
				float lerp2 = dots2 - (dots2 - dots3) * posY;
				height[x + y*Chunk::WIDTH] += (j*2 + 1) * (lerp1 - (lerp1 - lerp2)*posX);
			}
		}
	}
	for (int x = 0; x<Chunk::WIDTH; x++)
	{
		for (int y = 0; y<Chunk::WIDTH; y++)
		{
			int h =(int)( 10*height[x + y*Chunk::WIDTH] + 12.0f) - chunk.chunkCoord.z * Chunk::WIDTH;
			for (int z =0; z<Chunk::WIDTH; z++)
			{
				if (z>h && z + chunk.chunkCoord.z == 0)
					chunk.BlockData[chunk.BlockAt(x,y,z)] = WATER;
				else if (z>h)
					chunk.BlockData[chunk.BlockAt(x,y,z)] = AIR;
				else if (z==h)
					chunk.BlockData[chunk.BlockAt(x,y,z)] = GRASS;
				else if (z>h-3)
					chunk.BlockData[chunk.BlockAt(x,y,z)] = DIRT;
				else 
					chunk.BlockData[chunk.BlockAt(x,y,z)] = STONE;
			} 
		}
	}
}


int WorldGenerator::randNumGen(int baseSeed, int x)
{
	if (x==0) 
		return baseSeed;
	//else return (1103515245*randNumGen(baseSeed, (x<0) ? x+1 : x-1) + 12345)%0xFFFFFFFF;
	else return (48271*randNumGen(baseSeed, (x<0) ? x+1 : x-1))%0xFFFFFFFF;
}

glm::vec2 WorldGenerator::getVector(int seed, short x, short y)
{
	return glm::vec2(
		(float)randNumGen(seed + (y << 7), x)/0x100000000 * 2.0f,
		(float)randNumGen(seed + x,	y)/0x100000000 * 2.0f);
}

