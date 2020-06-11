#include "ChunkProvider.h"
#include <stdlib.h>
#include <stdio.h>

ChunkProvider::ChunkProvider(std::string folderName)
{
	_folderName = folderName;
}

bool ChunkProvider::LoadChunk(Chunk* chunk)
{
	if(chunk->_fresh)
	{
		char saveFile[50];
		sprintf(saveFile,"%s/%i.%i.%i.ch",_folderName.c_str(),chunk->GetChunkX(),chunk->GetChunkY(),chunk->GetChunkZ());

		FILE *file = fopen(saveFile,"rb");

		if(file != NULL)
		{
			chunk->_initData();

			fread(chunk->_blocks,sizeof(unsigned char),chunk->_chunkWidth * chunk->_chunkHeight * chunk->_chunkWidth,file);
			fclose(file);

			chunk->_fresh = false;
			chunk->_dirty = true;

			return true;
		}

		return false;
	}

	return true;	
}

bool ChunkProvider::SaveChunk(Chunk* chunk)
{
	if(chunk->_blocks == 0)
		return false;

	char saveFile[50];
	sprintf(saveFile,"%s/%i.%i.%i.ch",_folderName.c_str(),chunk->GetChunkX(),chunk->GetChunkY(),chunk->GetChunkZ());

	FILE *file = fopen(saveFile,"wb");

	if(file != NULL)
	{
		fwrite(chunk->_blocks,sizeof(unsigned char),chunk->_chunkWidth * chunk->_chunkHeight * chunk->_chunkWidth,file);
		fclose(file);

		return true;
	}

	return false;
}
