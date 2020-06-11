#include "wb-global.h"

#include "SdlSample.h"

const chi::SdlSample *superCast(const chi::Sample &sample) {
	const chi::SdlSample *sdlSample = dynamic_cast<const chi::SdlSample *>(&sample);

	if (!sdlSample) {
		throw chi::Exception("You can only assign an SdlSample from another SdlSample.");
	}

	return sdlSample;
}

namespace chi {

Factory<SdlSample> *SdlSample::factory = new Factory<SdlSample>;

SdlSample::SdlSample()
	: sample(NULL)
{
}

SdlSample::SdlSample(const SdlSample &sample)
	: Sample(sample)
{
	copyFrom(sample);
}

SdlSample::SdlSample(const Sample &sample)
	: Sample(sample)
{
	copyFrom(*superCast(sample));
}

SdlSample::SdlSample(const std::string &uri)
	: sample(Mix_LoadWAV((this->m_uri = uri).c_str()))
{

	if (!sample) {
		throw Exception("Mix_LoadWAV failed! SDL says, \"" + std::string(SDL_GetError()) + "\".");
	}
}

SdlSample::~SdlSample() {
	if (!m_sampleCounter.release()) return;

	if (!sample) return;

	Mix_FreeChunk(sample);
}

Sample &SdlSample::operator =(const Sample &sample) {
	Sample::operator =(sample);

	return copyFrom(*superCast(sample));
}

SdlSample &SdlSample::operator =(const SdlSample &sample) {
	Sample::operator =(sample);

	return copyFrom(sample);
}

SdlSample &SdlSample::copyFrom(const SdlSample &sample) {

	this->sample = sample.sample;

	return *this;
}


int SdlSample::play(int loops, int channel) {
	return Mix_PlayChannel(channel, sample, loops);
}

}
