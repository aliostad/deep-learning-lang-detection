#include "chunkgenerator.h"
#include "..\constants.h"

namespace Wanderlust
{
	bool chunkgenerator::GenerateChunk(chunk* Chunk)
	{
		blockID Stone = mBlockIndex->getBlockIDByName("Stone");
		blockID Dirt = mBlockIndex->getBlockIDByName("Dirt");
		blockID Grass = mBlockIndex->getBlockIDByName("Grass");
		for(int YIter = 0; YIter < CHUNK_SIZE; YIter++)
		{
			for(int XIter = 0; XIter < CHUNK_SIZE; XIter++)
			{
				for(int ZIter = 0; ZIter < CHUNK_SIZE; ZIter++)
				{
					if(((Chunk->getYPosition() * CHUNK_SIZE) + YIter) < (CHUNK_SIZE - 6))
					{
						Chunk->setBlock(XIter, YIter, ZIter, Stone);
					}
					else if(((Chunk->getYPosition() * CHUNK_SIZE) + YIter) < (CHUNK_SIZE - 3))
					{
						Chunk->setBlock(XIter, YIter, ZIter, Dirt);
					}
					else if(((Chunk->getYPosition() * CHUNK_SIZE) + YIter) < (CHUNK_SIZE - 2))
					{
						Chunk->setBlock(XIter, YIter, ZIter, Grass);
					}
					else
					{
						Chunk->setBlock(XIter, YIter, ZIter, 0);
					}
				}
			}
		}
		//Chunk->InitToZero();
		//Chunk->setBlock(0, 0, 0, 1);
		return true;
	}
	void chunkgenerator::regBlockIndex(blockindex* b)
	{
		mBlockIndex = b;
	}
}