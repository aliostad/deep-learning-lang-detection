#include "space.h"
#include <math.h>
#include <iostream>
namespace Wanderlust
{
	space::space()
	{
		mChunkGenPtr = 0;
		mTerrain.clear();
	}
	space::~space()
	{
		map<chunkposition, chunk*>::iterator iter = mTerrain.begin();
		while(iter != mTerrain.end())
		{
			delete iter->second; //Save first.
			iter++;
		}
		mTerrain.clear();
	}
	chunk* space::getChunk(real X, real Y, real Z)
	{
		if(mTerrain.find(chunkposition(X, Y, Z)) != mTerrain.end())
		{
			return mTerrain.find(chunkposition(X, Y, Z))->second;
		}
		else
		{
			return 0;
		}
	}
	chunk* space::getChunk(int X, int Y, int Z)
	{
		if(mTerrain.find(chunkposition(X, Y, Z)) != mTerrain.end())
		{
			return mTerrain.find(chunkposition(X, Y, Z))->second;
		}
		else
		{
			return 0;
		}
	}
	blockID space::getBlock(long int X, long int Y, long int Z)
	{
		real ChunkX, ChunkY, ChunkZ;
		ChunkX = (real)X/CHUNK_SIZE;
		ChunkY = (real)Y/CHUNK_SIZE;
		ChunkZ = (real)Z/CHUNK_SIZE;
		
		ChunkX = floor(ChunkX);
		ChunkY = floor(ChunkY);
		ChunkZ = floor(ChunkZ);
		chunk* FromWhich = getChunk(ChunkX, ChunkY, ChunkZ);
		if(FromWhich)
		{
			X %= CHUNK_SIZE; 
			Y %= CHUNK_SIZE; 
			Z %= CHUNK_SIZE;

			if(X < 0)
			{
				X = CHUNK_SIZE + X;
			}
			if(Y < 0)
			{
				Y = CHUNK_SIZE + Y;
			}
			if(Z < 0)
			{
				Z = CHUNK_SIZE + Z;
			}
			return FromWhich->getBlock(X, Y, Z);
		}
		else
		{
			return 0;
		}
	}
	bool space::getBlockExists(long int X, long int Y, long int Z)
	{
		real ChunkX, ChunkY, ChunkZ;
		ChunkX = (real)X/CHUNK_SIZE;
		ChunkY = (real)Y/CHUNK_SIZE;
		ChunkZ = (real)Z/CHUNK_SIZE;
		
		ChunkX = floor(ChunkX);
		ChunkY = floor(ChunkY);
		ChunkZ = floor(ChunkZ);
		chunk* ToWhich = getChunk(ChunkX, ChunkY, ChunkZ);
		if(ToWhich)
		{
			return true;
		}
		return false;
	}
	void space::setBlock(long int X, long int Y, long int Z, blockID SetTo)
	{
		real ChunkX, ChunkY, ChunkZ;
		ChunkX = (real)X/CHUNK_SIZE;
		ChunkY = (real)Y/CHUNK_SIZE;
		ChunkZ = (real)Z/CHUNK_SIZE;
		
		ChunkX = floor(ChunkX);
		ChunkY = floor(ChunkY);
		ChunkZ = floor(ChunkZ);
		chunk* ToWhich = getChunk(ChunkX, ChunkY, ChunkZ);
		if(ToWhich)
		{
			X %= CHUNK_SIZE; 
			Y %= CHUNK_SIZE; 
			Z %= CHUNK_SIZE;

			if(X < 0)
			{
				X = CHUNK_SIZE + X;
			}
			if(Y < 0)
			{
				Y = CHUNK_SIZE + Y;
			}
			if(Z < 0)
			{
				Z = CHUNK_SIZE + Z;
			}
			ToWhich->setBlock(X, Y, Z, SetTo);
		}
	}
	/*blockID* space::getBlockPtr(long int X, long int Y, long int Z)
	{
		real ChunkX, ChunkY, ChunkZ;
		ChunkX = (real)X/CHUNK_SIZE;
		ChunkY = (real)Y/CHUNK_SIZE;
		ChunkZ = (real)Z/CHUNK_SIZE;
		
		ChunkX = floor(ChunkX);
		ChunkY = floor(ChunkY);
		ChunkZ = floor(ChunkZ);
		chunk* FromWhich = getChunk(ChunkX, ChunkY, ChunkZ);
		if(FromWhich)
		{
			X %= CHUNK_SIZE; 
			Y %= CHUNK_SIZE; 
			Z %= CHUNK_SIZE;

			if(X < 0)
			{
				X = CHUNK_SIZE + X;
			}
			if(Y < 0)
			{
				Y = CHUNK_SIZE + Y;
			}
			if(Z < 0)
			{
				Z = CHUNK_SIZE + Z;
			}
			return FromWhich->getBlockPtr(X, Y, Z);
		}
		else
		{
			return 0;
		}
	}*/

	bool space::genChunk(int X, int Y, int Z)
	{
		if(mTerrain.find(chunkposition(X, Y, Z)) == mTerrain.end())
		{
			if(mChunkGenPtr)
			{
				mTerrain[chunkposition(X, Y, Z)] = new chunk;
				mTerrain.find(chunkposition(X, Y, Z))->second->setXPosition(X);
				mTerrain.find(chunkposition(X, Y, Z))->second->setYPosition(Y);
				mTerrain.find(chunkposition(X, Y, Z))->second->setZPosition(Z);
				mChunkGenPtr->GenerateChunk(mTerrain.find(chunkposition(X, Y, Z))->second);
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	bool space::unloadChunk(int, int, int)
	{
		return true;
	}
	bool space::saveChunk(int X, int Y, int Z)
	{
		return false;
	}
	
	void space::regChunkGen(chunkgenerator* Generator)
	{
		mChunkGenPtr = Generator;
	}
}
