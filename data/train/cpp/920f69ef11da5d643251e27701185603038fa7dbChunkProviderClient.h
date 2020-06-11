#ifndef CHUNKPROVIDERCLIENT_H
#define CHUNKPROVIDERCLIENT_H
#include <includes.h>

#include <Chunk\Chunk.h>
#include <Chunk\ChunkProviderClient.h>
#include <IChunkProvider.h>
#include <World\World.h>
#include <EmptyChunk.h>
#include <Chunk\ChunkCoordIntPair.h>
#include <IProgressUpdate.h>
#include <Chunk\ChunkCache.h>

class ChunkProviderClient
{
public:
	ChunkProviderClient(World world);
	boolean chunkExists(int i, int j);
	void func_539_c(int i, int j);
	Chunk func_538_d(int i, int j);
	Chunk provideChunk(int i, int j);
	boolean saveChunks(boolean flag, IProgressUpdate iprogressupdate);
	boolean func_532_a();
	boolean func_536_b();
	void populate(IChunkProvider ichunkprovider, int i, int j);
	String makeString();
protected:
private:
Chunk blankChunk;
Map chunkMapping;
List field_889_c;
World worldObj;
};

#endif //CHUNKPROVIDERCLIENT_H
