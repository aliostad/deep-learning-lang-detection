#include "stdafx.h"
#include "ChunkLoader.h"
#include "Chunk.h"
#include "zlib.h"

#include <thread>

using namespace vox;

ChunkLoader::ChunkLoader(void)	:
	_running(true), _thread(nullptr)
{
}


ChunkLoader::~ChunkLoader(void)
{
}

bool
ChunkLoader::Init(void)
{
	_thread = new (std::nothrow) std::thread(&vox::ChunkLoader::Run, this);
	if (_thread == nullptr)
		return false;
	return true;
}

void
ChunkLoader::Destroy(void)
{
	if (_thread != nullptr)
	{
		Quit();
		_thread->join();
		delete _thread;
	}
}

void
ChunkLoader::Run(void)
{
	while (_running)
	{
		ChunkToLoad*	toLoad = _GetChunkToLoad();
		
		if (toLoad == nullptr)
			Sleep(15);
		else
		{
			if (!_LoadChunk(toLoad))
				Quit();
		}
	}
}

bool
ChunkLoader::AddChunkToLoad(int x, int y, int z, void* data, int compressSize)
{
	try
	{
		ChunkToLoad*	toLoad = new (std::nothrow) ChunkToLoad;
		toLoad->x = x;
		toLoad->y = y;
		toLoad->z = z;
		toLoad->data = data;
		toLoad->compressSize = compressSize;
		 std::lock_guard<std::mutex> locker(_chunkToLoadMutex);
		_chunkToLoad.push(toLoad);
	}
	catch (std::bad_alloc)
	{
		delete data;
		return false;
	} 
	return true;
}

Chunk*
ChunkLoader::GetLoadedChunks(void)
{
	 std::unique_lock<std::mutex> locker(_chunkLoadedMutex,std::defer_lock);
	 if (locker.try_lock() && !_chunkLoaded.empty())
	 {
		 Chunk* toReturn = _chunkLoaded.front();
		 _chunkLoaded.pop();
		 return toReturn;
	 }
	 else
		 return nullptr;
}

ChunkLoader::ChunkToLoad*
ChunkLoader::_GetChunkToLoad(void)
{
	ChunkToLoad*	toLoad = nullptr;
	std::lock_guard<std::mutex> toLoadlocker(_chunkToLoadMutex);
	std::lock_guard<std::mutex> loadedlocker(_chunkLoadedMutex);
	if (!_chunkToLoad.empty() && _chunkLoaded.size() < 5)
	{
		toLoad = _chunkToLoad.front();
		_chunkToLoad.pop();
	}
	return toLoad;
}

bool
ChunkLoader::_LoadChunk(ChunkToLoad* toLoad)
{
	const int uncompressSize = Chunk::CHUNK_SIZE * Chunk::CHUNK_SIZE * Chunk::CHUNK_SIZE * sizeof(char);
	Bytef* uncompressData = new (std::nothrow) Bytef[uncompressSize];
	if (uncompressData == nullptr)
	{
		delete toLoad->data;
		delete toLoad;
		return false;
	}
	uLongf size = uncompressSize;
	uLongf compSize = toLoad->compressSize;
	int err = uncompress(uncompressData, &size, (Bytef*)toLoad->data, compSize);
	if (err != Z_OK)
	{
		fprintf(stderr, "error: %d == %d\n", err, Z_BUF_ERROR);
		delete toLoad->data;
		delete toLoad;
		return true;
	}
	delete toLoad->data;
	Chunk* chunk = new (std::nothrow) Chunk();
	if (chunk == nullptr ||
		!chunk->init(toLoad->x, toLoad->y, toLoad->z, (unsigned char*)uncompressData))
	{
		delete toLoad;
		delete chunk;
		return false;
	}
	delete toLoad;
	try
	{
		std::lock_guard<std::mutex> locker(_chunkLoadedMutex);
		_chunkLoaded.push(chunk);
	}
	catch (std::bad_alloc)
	{
		delete chunk;
		return false;
	}
	return true;
}