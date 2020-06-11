
#include <misc/sound_util.h>

#include <FileClasses/FileManager.h>
#include <FileClasses/Vocfile.h>

#include <SDL_mixer.h>
#include <stdlib.h>

extern FileManager* pFileManager;

Mix_Chunk* Concat2Chunks(Mix_Chunk* sound1, Mix_Chunk* sound2)
{
	Mix_Chunk* returnChunk;
	if((returnChunk = (Mix_Chunk*) malloc(sizeof(Mix_Chunk))) == NULL) {
		return NULL;
	}

	returnChunk->allocated = 1;
	returnChunk->volume = sound1->volume;
	returnChunk->alen = sound1->alen + sound2->alen;

	if((returnChunk->abuf = (Uint8 *)malloc(returnChunk->alen)) == NULL) {
		free(returnChunk);
		return NULL;
	}

	memcpy(returnChunk->abuf, sound1->abuf, sound1->alen);
	memcpy(returnChunk->abuf + sound1->alen, sound2->abuf, sound2->alen);

	return returnChunk;
}

Mix_Chunk* Concat3Chunks(Mix_Chunk* sound1, Mix_Chunk* sound2, Mix_Chunk* sound3)
{
	Mix_Chunk* returnChunk;
	if((returnChunk = (Mix_Chunk*) malloc(sizeof(Mix_Chunk))) == NULL) {
		return NULL;
	}

	returnChunk->allocated = 1;
	returnChunk->volume = sound1->volume;
	returnChunk->alen = sound1->alen + sound2->alen + sound3->alen;

	if((returnChunk->abuf = (Uint8 *)malloc(returnChunk->alen)) == NULL) {
		free(returnChunk);
		return NULL;
	}

	memcpy(returnChunk->abuf, sound1->abuf, sound1->alen);
	memcpy(returnChunk->abuf + sound1->alen, sound2->abuf, sound2->alen);
	memcpy(returnChunk->abuf + sound1->alen + sound2->alen, sound3->abuf, sound3->alen);

	return returnChunk;
}

Mix_Chunk* Concat4Chunks(Mix_Chunk* sound1, Mix_Chunk* sound2, Mix_Chunk* sound3, Mix_Chunk* sound4)
{
	Mix_Chunk* returnChunk;
	if((returnChunk = (Mix_Chunk*) malloc(sizeof(Mix_Chunk))) == NULL) {
		return NULL;
	}

	returnChunk->allocated = 1;
	returnChunk->volume = sound1->volume;
	returnChunk->alen = sound1->alen + sound2->alen + sound3->alen + sound4->alen;

	if((returnChunk->abuf = (Uint8 *)malloc(returnChunk->alen)) == NULL) {
		free(returnChunk);
		return NULL;
	}

	memcpy(returnChunk->abuf, sound1->abuf, sound1->alen);
	memcpy(returnChunk->abuf + sound1->alen, sound2->abuf, sound2->alen);
	memcpy(returnChunk->abuf + sound1->alen + sound2->alen, sound3->abuf, sound3->alen);
	memcpy(returnChunk->abuf + sound1->alen + sound2->alen + sound3->alen, sound4->abuf, sound4->alen);

	return returnChunk;
}

Mix_Chunk* CreateEmptyChunk()
{
	Mix_Chunk* returnChunk;
	if((returnChunk = (Mix_Chunk*) malloc(sizeof(Mix_Chunk))) == NULL) {
		return NULL;
	}

	returnChunk->allocated = 1;
	returnChunk->volume = 0;
	returnChunk->alen = 0;
	returnChunk->abuf = NULL;

	return returnChunk;
}

Mix_Chunk* CreateSilenceChunk(int length)
{
	Mix_Chunk* returnChunk;
	if((returnChunk = (Mix_Chunk*) malloc(sizeof(Mix_Chunk))) == NULL) {
		return NULL;
	}

	returnChunk->allocated = 1;
	returnChunk->volume = MIX_MAX_VOLUME;
	returnChunk->alen = length;

	if((returnChunk->abuf = (Uint8 *)calloc(returnChunk->alen,1)) == NULL) {
		free(returnChunk);
		return NULL;
	}

	return returnChunk;
}

Mix_Chunk* GetChunkFromFile(std::string Filename) {
	Mix_Chunk* returnChunk;
	SDL_RWops* rwop;

	if((rwop = pFileManager->OpenFile(Filename)) == NULL) {
		fprintf(stderr,"GetChunkFromFile(): Cannot open %s!\n",Filename.c_str());
		exit(EXIT_FAILURE);
	}

	if((returnChunk = LoadVOC_RW(rwop, 1)) == NULL) {
		fprintf(stderr,"GetChunkFromFile(): Cannot load %s!\n",Filename.c_str());
		exit(EXIT_FAILURE);
	}

	return returnChunk;
}

Mix_Chunk* GetChunkFromFile(std::string Filename, std::string AlternativeFilename) {
    if(pFileManager->exists(Filename)) {
        return GetChunkFromFile(Filename);
    } else if(pFileManager->exists(AlternativeFilename)) {
        return GetChunkFromFile(AlternativeFilename);
    } else {
		fprintf(stderr,"GetChunkFromFile(): Cannot open %s or %s!\n",Filename.c_str(), AlternativeFilename.c_str());
		exit(EXIT_FAILURE);
	}
	return NULL;
}
