#ifndef CHUNK_MANAGER_HPP
#define CHUNK_MANAGER_HPP

#include <unordered_set>
#include <vector>
#include <SFML/System/Vector2.hpp>
#include "Chunk.hpp"
#include "Util.hpp"

namespace eth
{
	class ChunkManager
	{
	public:
		ChunkManager();
		~ChunkManager();

		void initChunks(sf::Vector2f viewPosition);
		void update(float deltaTime, sf::Vector2f viewPosition);
		void render(sf::RenderWindow& window);

		Chunk* getChunk(int chunkX, int chunkY);

	private:
		std::vector<Chunk*> chunkList;

		std::unordered_set<Chunk*> nearbyChunks;
		std::unordered_set<Chunk*> loadList;
		std::unordered_set<Chunk*> unloadList;

		sf::Vector2i lastChunkCoords;
		float timePeriod;
		float timeElapsed;

		void queueLoadChunk(Chunk* chunk);
		void queueUnloadChunk(Chunk* chunk);

		void updateLoadList();
		void updateUnloadList();

		void loadChunk(Chunk* chunk);
		void unloadChunk(Chunk* chunk);

		void loadNextChunk();
		void unloadNextChunk();

		void forceLoadList();
		void forceUnloadList();

		bool isNearby(Chunk* chunk);
	};
}

#endif