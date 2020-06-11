#ifndef CHUNKPROVIDERLOADORGENERATE_H
#define CHUNKPROVIDERLOADORGENERATE_H
#include <includes.h>

#include <Chunk\Chunk.h>
#include <Chunk\ChunkProviderLoadOrGenerate.h>
#include <IChunkProvider.h>
#include <Chunk\ChunkLoader.h>
#include <IChunkLoader.h>
#include <World\World.h>
#include <EmptyChunk.h>
#include <IProgressUpdate.h>
#include <Chunk\ChunkCache.h>

class ChunkProviderLoadOrGenerate
{
public:
	ChunkProviderLoadOrGenerate(World world, IChunkLoader ichunkloader, IChunkProvider ichunkprovider);
	void setCurrentChunkOver(int i, int j);
	boolean canChunkExist(int i, int j);
	boolean chunkExists(int i, int j);
	Chunk func_538_d(int i, int j);
	Chunk provideChunk(int i, int j);
	void populate(IChunkProvider ichunkprovider, int i, int j);
	boolean saveChunks(boolean flag, IProgressUpdate iprogressupdate);
	boolean func_532_a();
	boolean func_536_b();
	String makeString();
protected:
private:
	Chunk func_542_c(int i, int j);
	void saveExtraChunkData(Chunk chunk);
	void saveChunk(Chunk chunk);
Chunk blankChunk;
IChunkProvider chunkProvider;
IChunkLoader chunkLoader;
Chunk chunks[];
World worldObj;
Chunk lastQueriedChunk;
int curChunkX;
int curChunkY;
};

#endif //CHUNKPROVIDERLOADORGENERATE_H
