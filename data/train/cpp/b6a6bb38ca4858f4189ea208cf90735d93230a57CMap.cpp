#include "CMap.hpp"

CMap::CMap() {

}

int CMap::getKey(int iChunkX, int iChunkY) {
	iChunkX &= 0xFFFF;
	iChunkY &= 0xFFFF;
	return (iChunkY << 16) | iChunkX;
}

void CMap::addMapChunk(int iChunkX, int iChunkY) {
	if (!mapChunkExist(iChunkX, iChunkY)) {
		CMapChunk *newMapChunk = new CMapChunk(iChunkX, iChunkY);
		mapChunks[getKey(iChunkX, iChunkY)] = newMapChunk;
	}
	fixChunkBorder(iChunkX, iChunkY);
}

void CMap::remMapChunk(int iChunkX, int iChunkY) {
	if (mapChunkExist(iChunkX, iChunkY)) {
		mapChunks.erase(getKey(iChunkX, iChunkY));
	}
	fixChunkBorder(iChunkX, iChunkY);
}

CMapChunk *CMap::getMapChunk(int iChunkX, int iChunkY) {
	if (mapChunkExist(iChunkX, iChunkY)) {
		return mapChunks[getKey(iChunkX, iChunkY)];
	}
	return NULL;
}

bool CMap::mapChunkExist(int iChunkX, int iChunkY) {
	if (mapChunks.count(getKey(iChunkX, iChunkY))) {
		return true;
	}
	return false;
}

void CMap::fixChunkBorder(int iChunkX, int iChunkY) {
	CMapChunk *centerChunk = getMapChunk(iChunkX, iChunkY);

	CMapChunk *request = getMapChunk(iChunkX, iChunkY + 1);
	if (centerChunk && request) {
		centerChunk->addState(CMAPCHUNK_STATE_HASUP);
		request->addState(CMAPCHUNK_STATE_HASDOWN);
	}
	else if (centerChunk) {
		centerChunk->remState(CMAPCHUNK_STATE_HASUP);
	}
	else if (request) {
		request->remState(CMAPCHUNK_STATE_HASDOWN);
	}

	request = getMapChunk(iChunkX - 1, iChunkY);
	if (centerChunk && request) {
		centerChunk->addState(CMAPCHUNK_STATE_HASLEFT);
		request->addState(CMAPCHUNK_STATE_HASRIGHT);
	}
	else if (centerChunk) {
		centerChunk->remState(CMAPCHUNK_STATE_HASLEFT);
	}
	else if (request) {
		request->remState(CMAPCHUNK_STATE_HASRIGHT);
	}

	request = getMapChunk(iChunkX, iChunkY - 1);
	if (centerChunk && request) {
		centerChunk->addState(CMAPCHUNK_STATE_HASDOWN);
		request->addState(CMAPCHUNK_STATE_HASUP);
	}
	else if (centerChunk) {
		centerChunk->remState(CMAPCHUNK_STATE_HASDOWN);
	}
	else if (request) {
		request->remState(CMAPCHUNK_STATE_HASUP);
	}

	request = getMapChunk(iChunkX + 1, iChunkY);
	if (centerChunk && request) {
		centerChunk->addState(CMAPCHUNK_STATE_HASRIGHT);
		request->addState(CMAPCHUNK_STATE_HASLEFT);
	}
	else if (centerChunk) {
		centerChunk->remState(CMAPCHUNK_STATE_HASRIGHT);
	}
	else if (request) {
		request->remState(CMAPCHUNK_STATE_HASLEFT);
	}
}

void CMap::update() {

}

void CMap::draw() {
	std::map<int, CMapChunk *>::iterator mapChunksIt = mapChunks.begin();

	for (; mapChunksIt != mapChunks.end(); ++mapChunksIt) {
		mapChunksIt->second->draw();
	}
}

void CMap::notify(IEvent *e) {
	
}