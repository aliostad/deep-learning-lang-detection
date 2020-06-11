
#pragma once

template <class T>
inline T determineZero() {
	return T();
}
//For primitives
template <>
inline float determineZero<float>() {
	return 0.0f;
}
template <>
inline double determineZero<double>() {
	return 0.0;
}
template <>
inline int determineZero<int>() {
	return 0;
}

#include "Savable.h"

template <class T>
class MovingAverage : public Savable {
	vector<T> samples;
	bool arrayFilled;
	int curSample;
	T lastAverage;
	unsigned int sampleId;
	int sampleSkip;
public:
	MovingAverage(int size, int sampleSkip = 0) : samples(size/((sampleSkip <= 0) ? 1 : sampleSkip)) {
		curSample = 0;
		sampleId = 0;
		this->sampleSkip = sampleSkip;
		arrayFilled = false;
		lastAverage = determineZero<T>();
	}

	void AddSample(T sample) {
		//Skip a certain number of samples if sampleSkip is selected
		if (sampleSkip > 0) {
			sampleId++;
			if ((sampleId % sampleSkip) != 0)
				return;
		}

		//Add the sample
		samples[curSample] = sample;
		curSample = (curSample + 1) % (int)samples.size();
		//Check if you looped over
		if (curSample == 0)
			arrayFilled = true;

		//Find the current average
		if (arrayFilled) {
			T total = determineZero<T>();
			for (auto sample : samples)
				total += sample;
			total /= samples.size();
			lastAverage = total;
		}
		else {

			T total = determineZero<T>();
			for (auto sample : samples)
				total += sample;

			if (curSample > 0)
				total /= curSample;
			lastAverage = total;
		}
	}

	void Clear() {
		arrayFilled = false;
		curSample = 0;
	}

	int GetSampleCount() {
		if (!arrayFilled)
			return curSample;
		return samples.size();
	}

	T GetAverage() {
		return lastAverage;
	}
	CLASS_DECLARATION(MovingAverage<T>)
		CLASS_CONTAINER_MEMBER(samples,ReflectionData::SAVE_VECTOR,ReflectionData::findReflectionType<T>())
		CLASS_MEMBER(curSample,ReflectionData::SAVE_INT32)
		CLASS_MEMBER(lastAverage,ReflectionData::findReflectionType<T>())
		CLASS_MEMBER(sampleId,ReflectionData::SAVE_UINT32)
		CLASS_MEMBER(sampleSkip,ReflectionData::SAVE_INT32)
	END_DECLARATION

};
