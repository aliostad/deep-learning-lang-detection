/*
 * ChunkManager.cpp
 *
 *  Created on: Mar 17, 2013
 *      Author: Tyler
 */

#include <iostream>

#include "Player.h"

#include "ChunkManager.h"

ChunkManager::ChunkManager() {
	mainPlayer = NULL;
}

ChunkManager::ChunkManager(Player * mainPlayer) {
	this->mainPlayer = mainPlayer;
	loadChunks(); //Temp?
}

ChunkManager::~ChunkManager() {
}

void ChunkManager::addChunk(int x, int y, int z, float r, float g, float b) {
	Chunk *chunk = new Chunk;
	chunk->init(x, y, z);
	chunk->setTestColor(r, g, b);
	chunks.push_back(chunk);
}

void ChunkManager::deleteChunk(int index) {
	delete chunks[index];
	chunks[index] = NULL;
}

void ChunkManager::update(time_t dt) {
	loadChunks();
	unloadChunks();

	std::vector<Chunk *>::iterator iterator;
	for (iterator = chunks.begin(); iterator != chunks.end(); iterator++) { //TODO add max limit per frame
		Chunk *chunk = *iterator;
		chunk->update(dt);
	}
}

void ChunkManager::draw(glm::mat4 *viewMat) {
	std::vector<Chunk *>::iterator iterator;
	for (iterator = chunks.begin(); iterator != chunks.end(); iterator++) { //TODO add max limit per frame
		Chunk *chunk = *iterator;
		chunk->draw(mainPlayer);
	}
}

Chunk * ChunkManager::getChunkWithCoordinate(int x, int y, int z) {
	Chunk * returnChunk = NULL;
	std::vector<Chunk *>::iterator iterator;
	for (iterator = chunks.begin(); iterator != chunks.end(); iterator++) { //TODO add max limit per frame
		Chunk *chunk = *iterator;
		glm::vec3 chunkPos = chunk->getChunkPos();
		bool inChunk = (x >= chunkPos.x && x < (chunkPos.x + Chunk::CHUNK_SIZE)) && (y >= chunkPos.y && y < (chunkPos.y + Chunk::CHUNK_SIZE))
				&& (z >= chunkPos.z && z < (chunkPos.z + Chunk::CHUNK_SIZE));
		if (inChunk) {
			returnChunk = chunk;
			break;
		}
	}
	return returnChunk;
}

void ChunkManager::loadChunks() { //TODO add max limit for chunks loaded per frame
	for (int x = floorf(mainPlayer->getPosition().x - (2 * Chunk::CHUNK_SIZE)); x < floorf(mainPlayer->getPosition().x + (2 * Chunk::CHUNK_SIZE)); x += Chunk::CHUNK_SIZE) { //TODO should this be done this way? or should flags be used
		for (int y = floorf(mainPlayer->getPosition().y - (1 * Chunk::CHUNK_SIZE)); y < floorf(mainPlayer->getPosition().y + (0 * Chunk::CHUNK_SIZE)); y += Chunk::CHUNK_SIZE) {
			for (int z = floorf(mainPlayer->getPosition().z - (2 * Chunk::CHUNK_SIZE)); z < floorf(mainPlayer->getPosition().z + (2 * Chunk::CHUNK_SIZE)); z += Chunk::CHUNK_SIZE) {
				Chunk * currentChunk = getChunkWithCoordinate(x - (x % Chunk::CHUNK_SIZE), y - (y % Chunk::CHUNK_SIZE), z - (z % Chunk::CHUNK_SIZE));
				if ((currentChunk != NULL && !(currentChunk->isLoaded())) || !currentChunk) {
					addChunk(x - (x % Chunk::CHUNK_SIZE), y - (y % Chunk::CHUNK_SIZE), z - (z % Chunk::CHUNK_SIZE), 1, 1, 1);
					return;
				}
			}
		}
	}
}

void ChunkManager::unloadChunks() {
	std::vector<Chunk *>::iterator iterator = chunks.begin();
	while (iterator != chunks.end()) { //TODO add max limit per frame
		Chunk *chunk = *iterator;
		float chunkX = chunk->getChunkPos().x, chunkY = chunk->getChunkPos().y, chunkZ = chunk->getChunkPos().z;
		int chunkSize = Chunk::CHUNK_SIZE;

		if (chunkX + chunkSize < floorf(mainPlayer->getPosition().x - (2 * chunkSize)) || chunkX >= floorf(mainPlayer->getPosition().x + (2 * chunkSize)) ||
				chunkY + chunkSize < floorf(mainPlayer->getPosition().y - (1 * chunkSize)) || chunkY >= floorf(mainPlayer->getPosition().y) ||
				chunkZ + chunkSize < floorf(mainPlayer->getPosition().z - (2 * chunkSize)) || chunkZ >= floorf(mainPlayer->getPosition().z + (2 * chunkSize))) {
//			chunk->deleteChunk()//fake function, create it eventually for saving, etc.
			delete chunk;
			iterator = chunks.erase(iterator);
		} else {
			++iterator;
		}
	}
}
