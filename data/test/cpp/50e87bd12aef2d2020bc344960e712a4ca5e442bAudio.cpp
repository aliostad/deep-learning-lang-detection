
#include "Advanced2D.h"

namespace Advanced2D {

	Sample::Sample()
	{
	}
	
	Sample::~Sample()
	{
		if (sample != NULL) {
			FMOD_Sound_Release(sample);
			sample = NULL;
		}
	}
	
	Audio::Audio()
	{
		system = NULL;
	}
	
	Audio::~Audio()
	{
		//release all samples
		for (Iterator i = samples.begin(); i != samples.end(); ++i)
		{
			(*i) = NULL;
		}
		
		FMOD_System_Release(system);
	}
	
	bool Audio::Init()
	{
		if (FMOD_System_Create(&system) != FMOD_OK) {
			return false;
		}
	
		if (FMOD_System_Init(system,100,FMOD_INIT_NORMAL,NULL) != FMOD_OK) {
			return false;
		}
	
		return true;
	}
	
	void Audio::Update()
	{
		FMOD_System_Update(system);
	}
	
	
	Sample* Audio::Load(std::string filename)
	{
		if (filename.length() == 0) return false;
		
		Sample *sample = new Sample();
	
		try {
			FMOD_RESULT res;
			res = FMOD_System_CreateSound(
				system, 			//FMOD system
				filename.c_str(), 	//filename
				FMOD_DEFAULT, 		//default audio
				NULL, 				//n/a
				&sample->sample);	//pointer to sample

			if (res != FMOD_OK) {
				sample = NULL;
			}
		} catch (...) {
			sample = NULL;
		}
			
		return sample;
	}
	
	bool Audio::Load(std::string filename, std::string name)
	{
		if (filename.length() == 0 || name.length() == 0) return false;
		
		Sample *sample = new Sample();
		sample->setName(name);
	
		try {
			FMOD_RESULT res;
			res = FMOD_System_CreateSound(
				system, 			//FMOD system
				filename.c_str(), 	//filename
				FMOD_DEFAULT, 		//default audio
				NULL, 				//n/a
				&sample->sample);	//pointer to sample

			if (res != FMOD_OK) {
				return false;
			}
		} catch (...) {
			return false;
		}
		samples.push_back(sample);
	
		return true;	
	}
	
	bool Audio::SampleExists(std::string name)
	{
		for (Iterator i = samples.begin(); i != samples.end(); ++i)
		{
			if ((*i)->getName() == name)
			{
				return true;
			}		 
		}
	
		return false;
	}
	
	bool Audio::IsPlaying(std::string name)
	{
		Sample *samp = FindSample(name);
		if (samp == NULL) return false;
		
		int index;
		FMOD_Channel_GetIndex(samp->channel, &index);
		
		// FMOD returns 99 if sample is playing, 0 if not
		return (index > 0);
		
	}
		
	Sample *Audio::FindSample(std::string name)
	{
		Sample *sample = NULL;
		for (Iterator i = samples.begin(); i != samples.end(); ++i)
		{
			if ((*i)->getName() == name)
			{
				sample = (*i);
				break;
			}
		}
		return sample;
	}
	
	
	bool Audio::Play(std::string name)
	{
		FMOD_RESULT res;
		Sample *sample = FindSample(name);
	
		if (sample->sample != NULL) {
			try {
				//sample found, play it
				res = FMOD_System_PlaySound(
					system,
					FMOD_CHANNEL_FREE, 
					sample->sample, 
					true, 
					&sample->channel);

				if (res!= FMOD_OK) return false;
				
				FMOD_Channel_SetLoopCount(sample->channel, -1);
				FMOD_Channel_SetPaused(sample->channel, false);
				
			} catch (...) {
				return false;
			}
		}
	
		return true;
	}
	
	bool Audio::Play(Sample *sample)
	{
		FMOD_RESULT res;
		if (sample == NULL) return false;
		if (sample->sample == NULL) return false;
	
		try {
			res = FMOD_System_PlaySound(
				system,
				FMOD_CHANNEL_FREE,
				sample->sample,
				true,
				&sample->channel);

			if (res!= FMOD_OK) return false;
	
			FMOD_Channel_SetLoopCount(sample->channel, -1);
			FMOD_Channel_SetPaused(sample->channel, false);
	
		} catch (...) {
			return false;
		}
	
		return true;
	}
	
	void Audio::Stop(std::string name)
	{
		if (!IsPlaying(name)) return;
	
		Sample *sample = FindSample(name);
		if (sample == NULL) return;
		
		FMOD_Channel_Stop(sample->channel);
	}
	
	void Audio::StopAll()
	{
		for (Iterator i = samples.begin(); i != samples.end(); ++i)
		{
			FMOD_Channel_Stop( (*i)->channel );
		}
	}
	
	void Audio::StopAllExcept(std::string name)
	{
		for (Iterator i = samples.begin(); i != samples.end(); ++i)
		{
			if ((*i)->getName() != name)
			{
				FMOD_Channel_Stop( (*i)->channel );
			}
		}
	}

};
