#include "async_world_generator.hpp"

#include <thread>
#include <atomic>

#include "shared/engine/logging.hpp"

using namespace std;

static logging::Logger logger("local");

AsyncWorldGenerator::AsyncWorldGenerator(WorldGenerator *worldGenerator) : Thread("AsyncChunkGenerator"),
	worldGenerator(worldGenerator),
	loadedQueue(1024),
	toLoadQueue(1024)
{
	dispatch();
}

AsyncWorldGenerator::~AsyncWorldGenerator() {
	Chunk *chunk;
	requestTermination();
	while (loadedQueue.pop(chunk));
	wait();
}

void AsyncWorldGenerator::doWork() {
	Chunk *chunk;
	if (toLoadQueue.pop(chunk)) {
		worldGenerator->generateChunk(chunk);
		while (!loadedQueue.push(chunk)) {
			sleepFor(millis(50));
		}
	} else {
		sleepFor(millis(100));
	}
}

bool AsyncWorldGenerator::generateChunk(Chunk *chunk) {
	return toLoadQueue.push(chunk);
}

Chunk *AsyncWorldGenerator::getNextChunk() {
	Chunk *chunk = nullptr;
	loadedQueue.pop(chunk);
	return chunk;
}
