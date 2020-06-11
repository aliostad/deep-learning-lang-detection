/*
 * SampledTone.cpp
 *
 *  Created on: Mar 5, 2010
 *      Author: ross
 */

#include "SampledTone.h"
#include <cmath>

SampledTone::SampledTone(jack_default_audio_sample_t freq, int framesPerSecond, float _amplitude) : frequency(freq)
        , sampleRate(framesPerSecond), sampleCount(0)
        , amplitude(_amplitude)
        , framesPerCycle((jack_default_audio_sample_t)framesPerSecond / frequency)
        , cycleEndSample(floor((framesPerCycle * 100000) + 0.5f)) {

    //cycleEndSample =
}

SampledTone::SampledTone() {

}

SampledTone::~SampledTone() {
    // TODO Auto-generated destructor stub
}

void SampledTone::init(jack_default_audio_sample_t freq, int framesPerSecond) {
    frequency = freq;
    sampleRate = framesPerSecond;
    sampleCount = 0;
    framesPerCycle = (jack_default_audio_sample_t)framesPerSecond / frequency;
    cycleEndSample = floor((framesPerCycle * 100000) + 0.5f);
}

jack_default_audio_sample_t SampledTone::getSample() {
    jack_default_audio_sample_t value = amplitude * sin(2.0f * SAMPLEDTONE_PI * (jack_default_audio_sample_t)sampleCount
            / framesPerCycle);

    ++sampleCount;
    if (sampleCount == cycleEndSample) {
        sampleCount = 0;
    }

    return value;
}
