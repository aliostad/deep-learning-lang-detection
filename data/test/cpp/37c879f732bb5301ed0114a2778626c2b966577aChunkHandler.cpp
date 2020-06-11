// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3.0.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License 3.0 for more details.

// Copyright (C) 2012-2013	filfat, xerpi, JoostinOnline

#include "ChunkHandler.hpp"


//Constructor
	ChunkHandler::ChunkHandler(Vertex32 *pos)
	{
		position = pos;
		int chunk_x, chunk_y, chunk_z;
		
		for(int z = 0;  z < WORLD_SIZE; z++)
		{
			for(int y = 0;  y < WORLD_SIZE; y++)
			{		
				for(int x = 0;  x < WORLD_SIZE; x++)
				{
					chunk_x = position->x + x * CHUNK_SIZE * BLOCK_SIZE;
					chunk_y = position->y + y * CHUNK_SIZE * BLOCK_SIZE;
					chunk_z = position->z + z * CHUNK_SIZE * BLOCK_SIZE;
					
					if(y < 2)
						chunkList.push_back(new Chunk(chunk_x, chunk_y, chunk_z, x, y, z, false));
					else
						chunkList.push_back(new Chunk(chunk_x, chunk_y, chunk_z, x, y, z, true));
				}
			}
		}
		
		generateNeighbours();
		updateChunks();
	}
	
//Destructor
	ChunkHandler::~ChunkHandler()
	{
		clearChunkList();
	}
	

//Methods

	Block *ChunkHandler::getBlockAtPosition(int x, int y, int z)
	{
		int chunk_x = floor(x / CHUNK_TOTAL_SIZE);
		int chunk_y = floor(y / CHUNK_TOTAL_SIZE);
		int chunk_z = floor(z / CHUNK_TOTAL_SIZE);
				
		int block_x = floor((x - (chunk_x * CHUNK_TOTAL_SIZE)) / BLOCK_SIZE);
		int block_y = floor((y - (chunk_y * CHUNK_TOTAL_SIZE)) / BLOCK_SIZE);
		int block_z = floor((z - (chunk_z * CHUNK_TOTAL_SIZE)) / BLOCK_SIZE);
			
		return chunkList[getWorldIndex(chunk_x, chunk_y, chunk_z)]->blockList[block_z][block_y][block_x];
	}

	void ChunkHandler::clearChunkList()
	{
		for(uint32_t i = 0; i < chunkList.size(); i++)
		{
			delete chunkList[i];	
		}
		chunkList.clear();		
	}
	
	void ChunkHandler::updateChunks()
	{
		std::vector<Chunk *>::iterator it;
		for(it = chunkList.begin(); it != chunkList.end(); it++)
		{
			if((*it)->needsUpdate)
				(*it)->generateMesh();
		}	
	}
	
	void ChunkHandler::generateNeighbours()
	{
		Chunk *chunkP;
		for(int z = 0;  z < WORLD_SIZE; z++)
		{
			for(int y = 0;  y < WORLD_SIZE; y++)
			{		
				for(int x = 0;  x < WORLD_SIZE; x++)
				{
					chunkP = chunkList[getWorldIndex(x, y, z)];
					
					//Left
						if(x == 0)
							chunkP->setLeftNeighbour(NULL);
						else
							chunkP->setLeftNeighbour(chunkList[getWorldIndex(x - 1, y, z)]);
					//Right
						if(x == (WORLD_SIZE-1))
							chunkP->setRightNeighbour(NULL);
						else
							chunkP->setRightNeighbour(chunkList[getWorldIndex(x + 1, y, z)]);					
					//Up
						if(y == (WORLD_SIZE-1))
							chunkP->setUpNeighbour(NULL);
						else
							chunkP->setUpNeighbour(chunkList[getWorldIndex(x, y + 1, z)]);
					//Down
						if(y == 0)
							chunkP->setDownNeighbour(NULL);
						else
							chunkP->setDownNeighbour(chunkList[getWorldIndex(x, y - 1, z)]);
					//Front
						if(z == (WORLD_SIZE-1))
							chunkP->setFrontNeighbour(NULL);
						else
							chunkP->setFrontNeighbour(chunkList[getWorldIndex(x, y, z + 1)]);
					//Back
						if(z == 0)
							chunkP->setBackNeighbour(NULL);
						else
							chunkP->setBackNeighbour(chunkList[getWorldIndex(x, y, z - 1)]);					
				}
			}
		}		
	}
	
	bool ChunkHandler::chunkInBounds(Chunk *chunkPointer)
	{
		if(chunkPointer != NULL)
		{
			if(chunkPointer->index.x >= 0 && chunkPointer->index.x < WORLD_SIZE &&
				chunkPointer->index.y >= 0 && chunkPointer->index.y < WORLD_SIZE &&
				chunkPointer->index.z >= 0 && chunkPointer->index.z < WORLD_SIZE)
				{
					return true;
				}
		}
		return false;
	}	
	
	void ChunkHandler::draw()
	{
		std::vector<Chunk *>::iterator it;
		for(it = chunkList.begin(); it != chunkList.end(); it++)
		{
			(*it)->draw();
		}		
	}
