#ifndef Chunk_H
	#define Chunk_H

#include <string>
#include <SDL2/SDL.h>

#ifdef APPLE
#include <SDL2_mixer/SDL_mixer.h>
#elif LINUX
#include <SDL2/SDL_mixer.h>
#elif WIN32
#include "SDL_mixer.h"
#endif

#include "E.h"

/**
 * Chunk class. Chunk wrapper class which plays loads and controls playing a sound chunk.
 */
class Chunk {

private:
	Mix_Chunk* chunk;

public:
	/**
	 * @brief Default constructor for Chunk
	 */
	Chunk();

	/**
	 * @brief Loads a Chunk from a file
	 *
	 * @param filename the filename of the Chunk
	 */
	bool Load(std::string filename);
	
	/**
	 * @brief Plays the sound Chunk
	 */
	void Play();
	
	/**
	 * @brief Pauses the currently playing Chunk
	 */
	void Pause();
	
	/**
	 * @brief Stops the currently playing Chunk
	 */
	void Stop();
	
	/**
	 * @brief Resumes the paused Chunk
	 */
	void Resume();
	
	/**
	 * @brief Destroys the Chunk
	 */
	void Destroy();
};

#endif
