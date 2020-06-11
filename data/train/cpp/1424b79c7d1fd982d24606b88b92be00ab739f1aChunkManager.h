#ifndef CHUNKMANAGER_H
#define CHUNKMANAGER_H

#include <stack>
#include <fstream>
#include <thread>
#include <mutex>

class Chunk;

class ChunkManager
{
public:
  ChunkManager();

  Chunk* GetLoadedCluster();
  void AsyncChunkUnload(Chunk** chunk, int num);
  void AsyncChunkLoad(int chunkX, int chunkY, int chunkZ);
  
private:
  void UnloadChunk(Chunk* chunk);
  Chunk* LoadChunk(int chunkX, int chunkY, int chunkZ);

  std::stack<Chunk*> loadStack;
  std::stack<Chunk*> unloadStack;
  std::thread loadThread;
  std::thread unloadThread;
  std::fstream readStream;
  std::fstream writeStream;
  bool unloadLive;
  bool loadLive;
  std::mutex loadMutex;
  std::mutex unloadMutex;


  enum ChunkTags : char
  {
    Undefined = 0,

    Start,
    Position,
    ChunkSize,
    BlockData,
    End
  };
};

#endif