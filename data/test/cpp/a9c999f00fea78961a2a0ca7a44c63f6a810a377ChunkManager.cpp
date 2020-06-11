#include "ChunkManager.h"
#include "Chunk.h"

ChunkManager* ChunkManager::_instance = 0;

ChunkManager::ChunkManager() {
	_generator = new ChunkGenerator();
}

ChunkManager::~ChunkManager() {
	std::vector<Chunk*>::iterator iterator;
	for(iterator = _chunkList.begin(); iterator != _chunkList.end(); iterator++) {
		delete *iterator;
	}

	_chunkList.~vector<Chunk*>();
	_chunkLoadList.~vector<Chunk*>();
	//chunkUnloadList.clear();
	//chunkSetupList.clear();
	//chunkVisibleList.clear();
	_chunkRenderList.~vector<Chunk*>();

	delete _generator;

	_instance = 0;
}

ChunkManager* ChunkManager::getInstance() {
   if (!_instance) {
      _instance = new ChunkManager;
   }
   return _instance;
}

void ChunkManager::pushChunk(Chunk* chunk) {
	_chunkList.push_back(chunk);
	_chunkLoadList.push_back(chunk);
	_chunkRenderList.push_back(chunk);
}

void ChunkManager::update() {
	updateLoadList();
	updateRenderList();
}

void ChunkManager::render() {
	std::vector<Chunk*>::iterator iterator;
	for(iterator = _chunkRenderList.begin(); iterator != _chunkRenderList.end(); iterator++) {
		Chunk* chunk = *iterator;

		if (chunk->isLoaded()) {
			chunk->render();
		}
	}
}

void ChunkManager::updateLoadList() {
	int amountOfChunksLoaded = 0;

    std::vector<Chunk*>::iterator iterator;   
    for(iterator = _chunkLoadList.begin(); iterator != _chunkLoadList.end(); iterator++) {
		Chunk* chunk = *iterator;

        if(!chunk->isLoaded()) {
            if(amountOfChunksLoaded < ASYNC_NUM_CHUNKS_PER_FRAME) {
				const clock_t begin_time = clock();
					_generator->generateChunk(chunk);
				std::cout << float( clock () - begin_time ) / CLOCKS_PER_SEC << std::endl;

                amountOfChunksLoaded++;
				if(amountOfChunksLoaded >= ASYNC_NUM_CHUNKS_PER_FRAME) {
					return;
				}
            }
        }
    }
	
	_chunkLoadList.clear();
}

void ChunkManager::updateRenderList() {
	std::vector<Chunk*>::iterator iterator;   
    for(iterator = _chunkRenderList.begin(); iterator != _chunkRenderList.end(); iterator++) {
		Chunk* chunk = *iterator;

        if(chunk->isLoaded() && chunk->isGenerated()) {
			chunk->update();
        }
    }
}

Chunk* ChunkManager::getChunkGivenWorldPosition(float x, float y, float z) {
	std::vector<Chunk*>::iterator iterator;   
    for(iterator = _chunkRenderList.begin(); iterator != _chunkRenderList.end(); iterator++) {
		Chunk* chunk = *iterator;
		return chunk;
    }
}