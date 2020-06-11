#include "SampleVectorsHolder.h"

///////////////////////////////////////////
// NOT USED
///////////////////////////////////////////

SampleVectorsHolder::~SampleVectorsHolder()
{
	delete[] sampleVectors;
	delete[] sampleClasses;
}

const float* SampleVectorsHolder::getSampleVectors()
{
	return this->sampleVectors;
}

const int* SampleVectorsHolder::getSampleClasses()
{
	return this->sampleClasses;
}

int SampleVectorsHolder::getSampleVectorCount()
{
	return this->sampleVectorsCount;
}

int SampleVectorsHolder::getSampleVectorRows()
{
	return this->sampleVectorRows;
}

int SampleVectorsHolder::getSampleVectorCols()
{
	return this->sampleVectorCols;
}