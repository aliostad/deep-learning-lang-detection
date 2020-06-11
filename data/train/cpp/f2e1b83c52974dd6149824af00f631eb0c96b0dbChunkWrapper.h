//! A wrapper for a SDL Mix_Chunk

#ifndef CHUNKWRAPPER_H
#define CHUNKWRAPPER_H

#include <SDL/SDL_mixer.h>

namespace SoundModule
{
	class ChunkWrapper
	{
	public:
		//! Pointer to the Mix_Chunk
		Mix_Chunk * _MixChunk;

		//! Standard constructor. Nulls the pointer
		ChunkWrapper(void) : _MixChunk(0)
		{
			// Intentionally left blank
		}

		//! Standard destructor, frees the Mix_chunk if it is not NULL
		~ChunkWrapper(void)
		{
			if(_MixChunk)
				Mix_FreeChunk(_MixChunk);
		}
	};
}

#endif // CHUNKWRAPPER_H

/*
History
=======
2006-06-30: Created file and implemented initial functionality
*/
