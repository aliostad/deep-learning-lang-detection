#include "ChunkManager.hpp"
#include <iostream>
namespace eth
{
	ChunkManager::ChunkManager()
		: lastChunkCoords(-1, -1), timePeriod(0.1f), timeElapsed(0)
	{
	}

	ChunkManager::~ChunkManager()
	{
		for(Chunk* chunk : nearbyChunks)
		{
			if(chunk)
			{
				delete chunk;
			}
		}

		for(Chunk* chunk : loadList)
		{
			if(chunk)
			{
				delete chunk;
			}
		}

		for(Chunk* chunk : unloadList)
		{
			if(chunk)
			{
				delete chunk;
			}
		}
	}

	void ChunkManager::initChunks(sf::Vector2f viewPosition)
	{
		for(int y = 0; y < GData::chunk_cols; y++)
		{
			for(int x = 0; x < GData::chunk_rows; x++)
			{
				chunkList.push_back(new Chunk(x, y));
			}
		}

		lastChunkCoords = Util::mapPositionToChunk(viewPosition);
		updateLoadList();
		forceLoadList();
	}

	void ChunkManager::update(float deltaTime, sf::Vector2f viewPosition)
	{
		timeElapsed += deltaTime;

		if(timeElapsed >= timePeriod)
		{
			timeElapsed -= timePeriod;
			loadNextChunk();
			unloadNextChunk();
		}

		sf::Vector2i chunkCoords = Util::mapPositionToChunk(viewPosition);
		if(lastChunkCoords != chunkCoords)
		{
			lastChunkCoords = chunkCoords;

			updateLoadList();
			updateUnloadList();
		}
	}

	void ChunkManager::render(sf::RenderWindow& window)
	{
		for(Chunk* chunk : nearbyChunks)
		{
			chunk->render(window);
		}
	}

	Chunk* ChunkManager::getChunk(int chunkX, int chunkY)
	{
		if(chunkX < 0 || chunkX >= GData::chunk_cols
		|| chunkY < 0 || chunkY >= GData::chunk_rows)
		{
			return nullptr;
		}

		return chunkList[chunkY * GData::chunk_cols + chunkX];
	}

	void ChunkManager::queueLoadChunk(Chunk* chunk)
	{
		if(chunk == nullptr || chunk->isLoaded())
			return;

		loadList.emplace(chunk);
	}

	void ChunkManager::queueUnloadChunk(Chunk* chunk)
	{
		if(chunk == nullptr || !chunk->isLoaded())
			return;

		unloadList.emplace(chunk);
	}

	void ChunkManager::loadChunk(Chunk* chunk)
	{
		chunk->load();
		nearbyChunks.emplace(chunk);
		std::cout << "Loaded: (" << chunk->getX() << "," << chunk->getY() << ")" << std::endl;
	}

	void ChunkManager::unloadChunk(Chunk* chunk)
	{
		chunk->unload();
		nearbyChunks.erase(chunk);
		std::cout << "~Unloaded: (" << chunk->getX() << "," << chunk->getY() << ")" << std::endl;
	}

	void ChunkManager::updateLoadList()
	{
		std::cout << "CURRENT CHUNK: (" << lastChunkCoords.x << "," << lastChunkCoords.y << ")" << " Nearby Chunks: " << nearbyChunks.size() << std::endl;

		queueLoadChunk(getChunk(lastChunkCoords.x, lastChunkCoords.y));
		queueLoadChunk(getChunk(lastChunkCoords.x, lastChunkCoords.y - 1));
		queueLoadChunk(getChunk(lastChunkCoords.x, lastChunkCoords.y + 1));
		queueLoadChunk(getChunk(lastChunkCoords.x + 1, lastChunkCoords.y));
		queueLoadChunk(getChunk(lastChunkCoords.x + 1, lastChunkCoords.y - 1));
		queueLoadChunk(getChunk(lastChunkCoords.x + 1, lastChunkCoords.y + 1));
		queueLoadChunk(getChunk(lastChunkCoords.x - 1, lastChunkCoords.y));
		queueLoadChunk(getChunk(lastChunkCoords.x - 1, lastChunkCoords.y - 1));
		queueLoadChunk(getChunk(lastChunkCoords.x - 1, lastChunkCoords.y + 1));
	}

	void ChunkManager::updateUnloadList()
	{
		for(Chunk* chunk : nearbyChunks)
		{
			if(!isNearby(chunk))
			{
				queueUnloadChunk(chunk);
			}
		}
	}

	void ChunkManager::loadNextChunk()
	{
		if(loadList.size() > 0)
		{
			Chunk* next = *loadList.begin();
			loadChunk(next);
			loadList.erase(next);
		}
	}

	void ChunkManager::unloadNextChunk()
	{
		if(unloadList.size() > 0)
		{
			Chunk* next = *unloadList.begin();
			unloadChunk(next);
			unloadList.erase(next);
		}
	}

	void ChunkManager::forceLoadList()
	{
		for(Chunk* chunk : loadList)
		{
			loadChunk(chunk);
		}

		loadList.clear();
	}

	void ChunkManager::forceUnloadList()
	{
		for(Chunk* chunk : unloadList)
		{
			unloadChunk(chunk);
		}

		unloadList.clear();
	}

	bool ChunkManager::isNearby(Chunk* chunk)
	{
		int diffX = lastChunkCoords.x - chunk->getX();
		int diffY = lastChunkCoords.y - chunk->getY();

		return !(diffX > 1 || diffX < -1
			  || diffY > 1 || diffY < -1);
	}
}