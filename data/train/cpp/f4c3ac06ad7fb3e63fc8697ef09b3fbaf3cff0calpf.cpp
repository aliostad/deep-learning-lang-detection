#include "lpf.h"
#include <math.h>
#include <stdio.h>

LPF::LPF(SoundProcessor *input) {
	this->input = input;
	pthread_mutex_init(&mutexsum, NULL);
	alpha = 0.1;
	started = false;
    period = 0.5*SAMPLE_RATE;
    phase = 0;
}

double LPF::getSample() {
	double outputSample, nextSample;
	nextSample = input->getSample();
	if(nextSample != nextSample)
		printf("NAN\n");
	if (!started) {
		started = true;
		lastOutputSample = nextSample;
		return nextSample;
	}
	outputSample = lastOutputSample + ((alpha+(0.05*sin(2*PI*phase/period))) * (nextSample - lastOutputSample));
	lastOutputSample = outputSample;
    phase = fmod(++phase, period);
	return outputSample*8;
}
