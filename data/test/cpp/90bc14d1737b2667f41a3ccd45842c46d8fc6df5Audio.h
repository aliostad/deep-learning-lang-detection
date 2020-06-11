#ifndef AUDIO_H
#define AUDIO_H

#include "Definitions.h"

class Audio
{
public:
	Audio()
	{
		sample = NULL;
	}
	~Audio()
	{
		al_destroy_sample(sample);
	}
	void Load(const char *filename)
	{
		sample = al_load_sample(filename);
	}
	void Reserve()
	{
		al_reserve_samples(1);
	}
	void Play(float gain, float pan, float speed, const char *playmode)
	{
		if (playmode == "PLAYMODE_ONCE")
			al_play_sample(sample, gain, pan, speed, ALLEGRO_PLAYMODE_ONCE, NULL);
		if (playmode == "PLAYMODE_LOOP")
			al_play_sample(sample, gain, pan, speed, ALLEGRO_PLAYMODE_LOOP, NULL);
	}
private:
	aSample sample;
};

#endif //AUDIO_H