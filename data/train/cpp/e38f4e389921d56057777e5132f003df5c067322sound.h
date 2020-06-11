#ifndef SOUND_H
#define SOUND_H

#include <string>

#include <allegro5/allegro.h>

#include "bass_crystalpicnic.h"

namespace Sound {

struct Sample {
	HSAMPLE sample;
	std::vector<HSAMPLE> set;
	float freq;
	bool is_set;
	bool loop;
};

Sample *load(std::string filename, bool loop = false);
Sample *load_set(std::string filename, std::string extension);
void destroy(Sample *sample);
void play(Sample *sample);
void play(Sample *sample, float volume, float pan, float speed);
void adjust(Sample *sample, float volume, float pan, float speed);
void stop(Sample *sample);

} // end namespace

#endif // SOUND_H

