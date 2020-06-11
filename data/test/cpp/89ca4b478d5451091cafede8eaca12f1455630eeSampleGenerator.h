/*
 * SampleGenerator.h
 *
 *  Created on: 4 Jul 2014
 *      Author: Kris Popat
 */

#ifndef SAMPLEGENERATOR_H_
#define SAMPLEGENERATOR_H_

#include <cstdint>

class SampleGenerator {
public:
	SampleGenerator( double inSampleRate ): sampleRate ( inSampleRate ){offsetDelta = 0;}
	virtual 	~SampleGenerator( ){}
	virtual int16_t	GetSample ( int16_t amplitude, double offset )=0;
	virtual double	CalculateDeltaForFrequency ( double noteFrequency )=0;

protected:
	double sampleRate;
	double offsetDelta;
};

#endif /* SAMPLEGENERATOR_H_ */
