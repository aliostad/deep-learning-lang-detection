/*
	File: SAMPLE.H
	Author: Henri Keeble
	Desc: Declares a simple sample class using BASS.
*/
#ifndef _SAMPLE_H_
#define _SAMPLE_H_

#include "BASS\bass.h"
#include <string>
#include "log.h"

namespace GameFramework
{
	class Sample
	{
	private:
		HSAMPLE sound;
		HCHANNEL channel;
	protected:
		HSAMPLE GetSample() const;
		HCHANNEL GetChannel() const;
	public:
		Sample();
		Sample(const char* filename);
		Sample(const Sample& param);
		Sample& operator=(const Sample& param);
		~Sample();

		virtual void Play();
		virtual void Stop();
		void Load(const char* filename);
	};
}

#endif // _SAMPLE_H_