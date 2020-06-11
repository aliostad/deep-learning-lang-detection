using namespace std;

///////////////////////////////////////////
// NOT USED
///////////////////////////////////////////

#pragma once

class SampleVectorsHolder
{
private:
	const float* sampleVectors;
	const int* sampleClasses;
	const int sampleVectorsCount;
	const int sampleVectorRows;
	const int sampleVectorCols;

public:
	SampleVectorsHolder(const float* sampleVectors, const int* sampleClasses, const int sampleVectorsCount, const int sampleVectorRows, const int sampleVectorCols)
		: sampleVectors(sampleVectors),sampleClasses(sampleClasses), sampleVectorsCount(sampleVectorsCount), sampleVectorRows(sampleVectorRows), sampleVectorCols(sampleVectorCols)
	{ }

	~SampleVectorsHolder();

	const float* getSampleVectors();

	const int* getSampleClasses();

	int getSampleVectorCount();

	int getSampleVectorRows();

	int getSampleVectorCols();
};