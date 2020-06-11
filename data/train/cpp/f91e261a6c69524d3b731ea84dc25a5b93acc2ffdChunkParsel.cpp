// dChunkParsel.cpp: implementation of the dChunkParsel class.
//
//////////////////////////////////////////////////////////////////////
#include <stdafx.h>
#include "dTree.h"
#include "dChunkParsel.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

dChunkParsel::dChunkParsel(FILE *file)
	:dTree<dChunkDescriptor, dUnsigned32>()  
{
	//RegisterChunk ('MAIN', ParceMainChunk, "Main chunk parce");
}

dChunkParsel::~dChunkParsel()
{
}


void dChunkParsel::RegisterChunk (dUnsigned32 m_chunkID, ChunkPosses fnt, const char* description)
{
	dChunkDescriptor header;

	header.m_readFnction = fnt;
	header.m_descrition = description;
}		   


dInt32 dChunkParsel::ParceMainChunk() const
{
	return 0;
}


void dChunkParsel::ParceFile()
{

}