#ifndef LUA_SDL_OBJECTS_CHUNK_H
#define LUA_SDL_OBJECTS_CHUNK_H

#include "common.hpp"

namespace LuaSDL {

	class MixChunk : public Object<Mix_Chunk> {
	public:
		explicit MixChunk(State * state) : Object<Mix_Chunk>(state) {
			LUTOK_METHOD("play", &MixChunk::play);
			LUTOK_METHOD("fadeIn", &MixChunk::fadeIn);
			LUTOK_PROPERTY("volume", &MixChunk::getVolume, &MixChunk::setVolume);
			LUTOK_PROPERTY("buf", &MixChunk::getBuf, &MixChunk::setBuf);
		}

		void destructor(State & state, Mix_Chunk * chunk){
			Mix_FreeChunk(chunk);
		}

		int getVolume(State & state, Mix_Chunk * chunk);
		int setVolume(State & state, Mix_Chunk * chunk);
		int play(State & state, Mix_Chunk * chunk);
		int fadeIn(State & state, Mix_Chunk * chunk);

		int getBuf(State & state, Mix_Chunk * chunk);
		int setBuf(State & state, Mix_Chunk * chunk);
	};
}

#endif
