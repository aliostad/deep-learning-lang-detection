/*
 * RssiFilter.cpp
 *
 *  Created on: 2015年4月7日
 *      Author: ghosty
 */

#include "RssiFilter.h"

CRssiFilter::CRssiFilter() {
	// TODO Auto-generated constructor stub
	for (int i=0; i<filterLength; i++)
		sampleValue[i]=0;
	sampleIndex = 0;
}

CRssiFilter::~CRssiFilter() {
	// TODO Auto-generated destructor stub
}

float CRssiFilter::Sampling(int value)
{
	sampleValue[sampleIndex] = value;
	if (++sampleIndex>=filterLength) {
		sampleIndex=0;
	}

	int sampleSum = 0;
	for (int i=0; i<filterLength; i++) {
		sampleSum += sampleValue[i];
	}
	return (float)sampleSum/filterLength;
}

