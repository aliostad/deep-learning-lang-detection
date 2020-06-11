#include "Sound.h"

//constructor
CSound::CSound(char* filename)
{
	//load in the chunk
	m_pChunk=Mix_LoadWAV(filename);
}

//destructor
CSound::~CSound()
{
	//free the chunk
	if(m_pChunk)
	{
		Mix_FreeChunk(m_pChunk);
	}
}

//get chunk
Mix_Chunk* CSound::GetChunk()
{
	//retrieve the chunk
	return(m_pChunk);
}

//check for a valid chunk
bool CSound::IsValid()
{
	//check if chunk is non-null
	return(GetChunk()!=NULL);
}

//set volume
void CSound::SetVolume(int volume)
{
	if(!IsValid()) return;
	//set a new volume
	Mix_VolumeChunk(GetChunk(),volume);
}

//get volume
int CSound::GetVolume()
{
	if(!IsValid()) return(-1);
	//return the volume of a chunk
	return(Mix_VolumeChunk(GetChunk(),-1));
}

