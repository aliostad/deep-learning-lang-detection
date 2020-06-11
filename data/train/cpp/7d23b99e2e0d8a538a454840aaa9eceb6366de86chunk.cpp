#include "Chunk.h"
#include "chunk.h"
#include "NBT_Debug.h"
#include "NBT_Tag.h"
#include "NBT_Tag_Compound.h"
#include "NBT_Tag_Byte_Array.h"
#include "lua/nbt.h"

LuaChunk::LuaChunk(Chunk *chunk) : chunk(chunk)
{
	level = chunk->nbt()->getCompound("Level");
	ba = nbt->getByteArray("
}
int LuaChunk::block(int x, int z)
{
	NBT_Tag_Compound *nbt = chunk->nbt();
	
}

void register_chunk(LuaGlue &glue)
{
	glue.Class<Chunk>("Chunk").
		ctor<int, int, int, int, int>("new").
		method("load", &Chunk::load).
		method("save", &Chunk::save).
		method("x", &Chunk::x).
		method("y", &Chunk::z).
		method("setTimestamp", &Chunk::setTimestamp).
		method("getTimestamp", &Chunk::getTimestamp).
		method("offset", &Chunk::offset).
		method("len", &Chunk::len).
		method("nbt", &Chunk::nbt).
}
