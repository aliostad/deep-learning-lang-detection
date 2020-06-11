#ifndef AVOCADO_SDLSSAMPLE_H
#define AVOCADO_SDLSSAMPLE_H

#include "core/avocado-global.h"

#include "SDL/SDL.h"
#include "SDL/SDL_mixer.h"

#include "core/Sound/Sample.h"

namespace avo {

/**
 * @addtogroup Sound
 * @{
 */

class SdlSample;

/**
 * @ingroup Resources
 * @ingroup SDL
 */
class SdlSample : public Sample {

public:

	SdlSample();
	SdlSample(const SdlSample &counter);
	SdlSample(const Sample &counter);

	/**
	 * Load a Mix_Chunk from a resource location.
	 */
	SdlSample(const boost::filesystem::path &uri);

	/**
	 * Release a Mix_Chunk
	 */
	~SdlSample();

	int play(int loops = 0);

	/**
	 * The amount of memory in bytes that SDL_mixer reports this sample is
	 * consuming.
	 */
	unsigned int sizeInBytes();

	static AbstractFactory<SdlSample> *factory;

private:

	Mix_Chunk *sample;

};

/**
 * @ingroup Manufacturing
 * @ingroup Resources
 * @ingroup SDL
 * @ingroup SPI
 */
template <>
class AbstractFactory<SdlSample> : public AbstractFactory<Sample> {

public:

	virtual ~AbstractFactory<SdlSample>() {}

	Sample *create() { return new SdlSample(); }
	Sample *create(const boost::filesystem::path &uri) { return new SdlSample(uri); }

};

/**
 * @}
 */

}

#endif // AVOCADO_SDLSSAMPLE_H
