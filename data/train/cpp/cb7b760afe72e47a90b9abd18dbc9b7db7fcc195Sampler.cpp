#include "stdafx.h"
#include "Sampler.h"
#include "Sample.h"


Sampler::Sampler() {
	width = 0;
	height = 0;
	x = 0.5;
	y = 0.5;
	firstSample = true;
}

Sampler::Sampler(float width, float height) {
	this->width = width;
	this->height = height;
	x = 0.5;
	y = 0.5;
	firstSample = true;
}

bool Sampler::getSample(Sample* sample) {
	if (firstSample == true) {
		firstSample = false;
		*sample = Sample(x, y);
		return true;
	}

	x = x + 1;

	if (x > width - 1 && y > height - 1) {        //may need to subtract 1 from height and width
		return false;
	}

	if (x > width) {
		x = 0.5;
		y = y + 1;
	}

	*sample = Sample(x, y);
	return true;
}
