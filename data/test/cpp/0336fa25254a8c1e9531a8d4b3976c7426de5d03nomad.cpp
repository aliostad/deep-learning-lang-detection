#include "Nomad.h"
#include "main.h"

int viewportX = 0;
int viewportY = 0;

Nomad::Nomad() {}
Nomad::Nomad(int xpos, int ypos) {
	this->xpos = xpos;
	this->ypos = ypos;
	this->currentChunk = 0;
}

int Nomad::getXpos() {
	return xpos;
}
int Nomad::getYpos() {
	return ypos;
}
int Nomad::getCurrentChunk() {
	return currentChunk;
}

void Nomad::moveUp() {
	//If exiting chunk
	if (ypos == world.getChunkByIndex(world.numOfChunks() - 1).ypos * chunkHeight) {
		if (world.newChunk(world.getChunkByIndex(world.numOfChunks() - 1).xpos, world.getChunkByIndex(world.numOfChunks() - 1).ypos - 1)) {
			currentChunk++;
		} else {
			currentChunk = world.getChunkCoords(xpos, ypos)[0];
		}
	}
	ypos--;
	//makes sure viewport shows player
	if (ypos < viewportY) {
		viewportY--;
	}
}
void Nomad::moveDown() {
	if (ypos == (world.getChunkByIndex(world.numOfChunks() - 1).ypos + 1) * chunkHeight - 1) {
		if (world.newChunk(world.getChunkByIndex(world.numOfChunks() - 1).xpos, world.getChunkByIndex(world.numOfChunks() - 1).ypos + 1)) {
			currentChunk++;
		} else {
			currentChunk = world.getChunkCoords(xpos, ypos)[0];
		}
	}
	ypos++;
	//makes sure viewport shows player
	if (ypos >= viewportY + viewportHeight) {
		viewportY++;
	}
}
void Nomad::moveLeft() {
//	if (xpos + 1 == world.getChunkByIndex(world.numOfChunks() - 1).xpos * chunkWidth - 1) {
//	//if (xpos - 1 = (newestChunk.xpos - 1) * chunkWidth
//	if (xpos - 1 == (world.getChunkByIndex(world.numOfChunks() - 1).xpos - 1 ) * chunkWidth) {
	// new position invalid
	if (world.get(xpos - 1, ypos) == (Material) -1) {
		// newChunk at 
		if (world.newChunk(world.getChunkByIndex(currentChunk).xpos - 1, world.getChunkByIndex(currentChunk).ypos)) {
			currentChunk = world.numOfChunks();
		} else {
			currentChunk = world.getChunkCoords(xpos, ypos)[0];
		}
//		if (world.newChunk(world.getChunkByIndex(world.numOfChunks() - 1).xpos - 1, world.getChunkByIndex(world.numOfChunks() - 1).ypos)) {
//			currentChunk++;
//		} else {
//			currentChunk = world.getChunkCoords(xpos, ypos)[0];
//		}
	}
	xpos--;
	//makes sure viewport shows player
	if (xpos < viewportX) {
		viewportX--;
	}
}
void Nomad::moveRight() {
	//if exiting chunk
	//if xpos + 1 = (chunkAtIndex(mostRecentChunk).xpos + 1) * chunk width
	if (xpos + 1 == (world.getChunkByIndex(world.numOfChunks() - 1).xpos + 1) * chunkWidth) {
		if (world.newChunk(world.getChunkByIndex(world.numOfChunks() - 1).xpos + 1, world.getChunkByIndex(world.numOfChunks() - 1).ypos)) {
			currentChunk++;
		} else {
			currentChunk = world.getChunkCoords(xpos, ypos)[0];
		}
	}
	xpos++;
	//makes sure viewport shows player
	if (xpos >= viewportX + viewportWidth) {
		viewportX++;
	}
}