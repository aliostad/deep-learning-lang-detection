/*
 * Basic Definitions and Configurations for the whole Project
 *
 */
#ifndef RPISYNTH_HPP_
#define RPISYNTH_HPP_

#include <cstdint>
#include "../fpml/fixed_point.h"

namespace rpisynth {
// basic sample type (e.g INT8, INT16,...)
typedef fpml::fixed_point<int16_t, 0> sample_t;
//typedef int16_t sample_t;

double constexpr SAMPLE_RATE = 48000.0;
int constexpr FRAMES_PER_BUFFER = 64;
int constexpr BITRATE = 16;
double constexpr BASE_TUNING = 440.0;

double constexpr toneMaxVal = 0.75;

constexpr sample_t sampleMaxVal() {
	return sample_t(toneMaxVal);//sample_t(toneMaxVal);
}
constexpr sample_t sampleMinVal() {
	return sample_t(-toneMaxVal);
}
constexpr sample_t sampleSilentVal() {
	return sample_t(0.0);
}

double getFrequency(uint8_t midi_note);

#define SAMPLE_FORMAT portaudio::INT16

}

#endif /* RPISYNTH_HPP_ */
