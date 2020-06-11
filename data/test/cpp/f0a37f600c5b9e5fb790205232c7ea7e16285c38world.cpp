#include <vector>
#include <iostream>
#include "main.h"
#include "Chunk.h"
#include "World.h"
using namespace std;


World::World() {
	chunks = vector<Chunk>(1, Chunk(0, 0));
}
World::~World() {
	
}

bool World::newChunk(int x, int y) {
	//if chunk doesn't exist
	if (getChunkIndex(x, y) == -1) {
		chunks.push_back(Chunk(x, y));
		return true;
	}
	return false;
}

//bool World::chunkExists() {
//	return false;
//}

Material World::get(int x, int y) {
	int subChunkX, subChunkY, chunkX, chunkY;
	
	if (x < chunkWidth && x > -chunkWidth) {
		subChunkX = x % chunkWidth;
	} else {
		subChunkX = x;
	}
	if (y < chunkHeight && y > -chunkHeight) {
		subChunkY = y % chunkHeight;
	} else {
		subChunkY = y;
	}

	chunkX = (x - subChunkX) / chunkWidth;
	chunkY = (y - subChunkY) / chunkHeight;

	if (getChunkIndex(chunkX , chunkY) != -1) {
		return chunks[getChunkIndex(chunkX , chunkY)].terrain[subChunkX][subChunkY];
	} else {
		return (Material) -1;
	}
}

int* World::getAbsCoords(int chunkIndex, int x, int y) {
	int absCoords[2];
	int chunkX = chunks[chunkIndex].xpos;
	int chunkY = chunks[chunkIndex].ypos;

	absCoords[0] = (chunkX * chunkWidth) + x;
	absCoords[1] = (chunkY * chunkHeight) + y;
	
	int* coordsToReturn = absCoords;
	return coordsToReturn;
}

int* World::getChunkCoords(int x, int y) {
	int chunkCoords[3];
	int subChunkX = x % chunkWidth;
	int subChunkY = y % chunkHeight;
	int chunkX = x - subChunkX;
	int chunkY = y - subChunkY;
	
	chunkCoords[0] = getChunkIndex(chunkX, chunkY);
	chunkCoords[1] = subChunkX;
	chunkCoords[2] = subChunkY;

	int* coordsToReturn = chunkCoords;
	return coordsToReturn;
}

Chunk World::getChunkByIndex(int index) {
	return chunks.at(index);
}

int World::numOfChunks() {
	return chunks.size();
}

int World::getChunkIndex(int x, int y) {
	for (vector<Chunk>::size_type i = 0; i != chunks.size(); i++) {
		if (chunks[i].xpos == x && chunks[i].ypos == y) {
			return i;
		}
	}
	return -1;
}

int World::chunkIndexAbove(int chunkIndex) {
	for (vector<Chunk>::size_type i = 0; i != chunks.size(); i++) {
		if (chunks[chunkIndex].xpos == chunks[i].xpos && chunks[chunkIndex].ypos == chunks[i].ypos - 1) {
			return i;
		}
	}
	return - 1;
}

int World::chunkIndexBelow(int chunkIndex) {
	for (vector<Chunk>::size_type i = 0; i != chunks.size(); i++) {
		if (chunks[chunkIndex].xpos == chunks[i].xpos && chunks[chunkIndex].ypos == chunks[i].ypos + 1) {
			return i;
		}
	}
	return - 1;
}

int World::chunkIndexLeft(int chunkIndex) {
	for (vector<Chunk>::size_type i = 0; i != chunks.size(); i++) {
		if (chunks[chunkIndex].xpos == chunks[i].xpos - 1 && chunks[chunkIndex].ypos == chunks[i].ypos) {
			return i;
		}
	}
	return - 1;
}

int World::chunkIndexRight(int chunkIndex) {
	for (vector<Chunk>::size_type i = 0; i != chunks.size(); i++) {
		if (chunks[chunkIndex].xpos == chunks[i].xpos + 1 && chunks[chunkIndex].ypos == chunks[i].ypos) {
			return i;
		}
	}
	return - 1;
}