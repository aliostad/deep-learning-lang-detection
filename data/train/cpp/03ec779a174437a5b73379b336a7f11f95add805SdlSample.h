#ifndef WB_SDLSSAMPLE_H
#define WB_SDLSSAMPLE_H

#include "wb-global.h"

#include "SDL/SDL.h"
#include "SDL/SDL_mixer.h"

#include "../Sample.h"

namespace chi {

/**
 * @addtogroup Sounds
 * @{
 */

class SdlSample;

/**
 * @ingroup Resources
 */
template<>
class ResourceManager<SdlSample> : public ResourceManager<Sample> {

public:

	static Factory<SdlSample> *factory;

};

/**
 * @ingroup @SDL
 */
class SdlSample : public Sample {

public:

	SdlSample();
	SdlSample(const SdlSample &counter);
	SdlSample(const Sample &counter);

	/**
	 * Load a sample from a resource location.
	 *
	 * @param uri
	 *   The location of the sample resource to load.
	 */
	SdlSample(const std::string &uri);

	~SdlSample();

	Sample &operator =(const Sample &sample);
	SdlSample &operator =(const SdlSample &sample);

	SdlSample &copyFrom(const SdlSample &sample);

	/**
	 * Play a sample.
	 *
	 * @param loops
	 *   Number of times to repeat.
	 * @param channel
	 *   %Sound channel to play the sample on.
	 */
	int play(int loops = 0, int channel = AnyChannel);

	static Factory<SdlSample> *factory;

private:

	Mix_Chunk *sample;

};

/**
 * @ingroup Resources
 * @ingroup SDL
 */
template <>
class Factory<SdlSample> : public Factory<Sample> {

public:

	Sample *create() { return new SdlSample(); }
	Sample *create(const std::string &uri) { return new SdlSample(uri); }

};

/**
 * @}
 */

}

#endif // WB_SDLSSAMPLE_H
