#pragma once

#include "Classifier.h"

class LimitedV1_kNCN: public Classifier {
public:
	static LoggerPtr logger;

	Distance** distances;
	Distance** nndists;

	SampleSet centroids;

	float percentMaxRobustRank;

	LimitedV1_kNCN(const int k, const int nrTrainSamples, const int nrTestSamples, 
		const int nrClasses, const int nrDims, const float percentMRobust);
	~LimitedV1_kNCN();

	void preprocess(const SampleSet& trainSet, const SampleSet& testSet);
	void classify(const SampleSet& trainSet, const SampleSet& testSet);
	int classifySample(const SampleSet& trainSet, const Sample& testSample,
		Distance* testSampleDists, Distance* testSampleNNdists, const int k);
	int classifySample(const SampleSet& trainSet, const Sample& testSample);

private:
	LimitedV1_kNCN();

	const Distance find1NNLimited(const SampleSet& trainSet, const Sample& testSample,
		const Distance* testSampleDists, const int maximalRobustRank);

	void findkNCNLearn(const SampleSet& trainSet, const Sample& testSample,
		Distance* testSampleDists, Distance* testSampleNNdists, const int k);
	void findkNCNLearn(const SampleSet& trainSet, const Sample& testSample);

	void findkNCNLimitedV1(const SampleSet& trainSet, const Sample& testSample,
		Distance* testSampleDists, Distance* testSampleNNdists, const int k);
	void findkNCNLimitedV1(const SampleSet& trainSet, const Sample& testSample);

	void learnMRobustRank(const SampleSet& trainSet);

	int assignLabel(const int testSampleIndex);
};