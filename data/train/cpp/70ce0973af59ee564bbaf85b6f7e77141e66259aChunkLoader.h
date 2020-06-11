#ifndef CHUNKLOADER_H
#define CHUNKLOADER_H
#include <includes.h>

#include <Chunk\Chunk.h>
#include <Chunk\ChunkLoader.h>
#include <IChunkLoader.h>
#include <World\World.h>
#include <CompressedStreamTools.h>
#include <NBT\NBTTagCompound.h>
#include <Block\Block.h>
#include <Session.h>
#include <World\WorldInfo.h>
#include <NBT\NBTTagList.h>
#include <Entity\Entity.h>
#include <TileEntity.h>
#include <NibbleArray.h>
#include <Entity\EntityList.h>

class ChunkLoader
{
public:
	ChunkLoader(File file, boolean flag);
	Chunk loadChunk(World world, int i, int j);
	void saveChunk(World world, Chunk chunk);
	static void storeChunkInCompound(Chunk chunk, World world, NBTTagCompound nbttagcompound);
	static Chunk loadChunkIntoWorldFromCompound(World world, NBTTagCompound nbttagcompound);
	void func_814_a();
	void saveExtraData();
	void saveExtraChunkData(World world, Chunk chunk);
protected:
private:
	File chunkFileForXZ(int i, int j);
File saveDir;;
boolean createIfNecessary;;
};

#endif //CHUNKLOADER_H
