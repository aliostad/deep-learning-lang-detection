#pragma once

#include "Classifier.h"

class LimitedV2_kNCN: public Classifier {
public:
	static LoggerPtr logger;

	Distance** distances;
	Distance** nndists;

	SampleSet centroids;

	float percentMaxRobustRank;

	LimitedV2_kNCN(const int k, const int nrTrainSamples, const int nrTestSamples, 
		const int nrClasses, const int nrDims, const float percentMRobust);
	~LimitedV2_kNCN();

	void preprocess(const SampleSet& trainSet, const SampleSet& testSet);
	void classify(const SampleSet& trainSet, const SampleSet& testSet);
	int classifySample(const SampleSet& trainSet, const Sample& testSample,
		Distance* testSampleDists, Distance* testSampleNNdists, const int k);
	int classifySample(const SampleSet& trainSet, const Sample& testSample);

private:
	LimitedV2_kNCN();

	const Distance find1NNLimited(const SampleSet& trainSet, const Sample& testSample,
		const Distance* testSampleDists, const int maximalRobustRankx);

	void findkNCNLearn(const SampleSet& trainSet, const Sample& testSample,
		Distance* testSampleDists, Distance* testSampleNNdists, const int k);
	void findkNCNLearn(const SampleSet& trainSet, const Sample& testSample);

	void findkNCNLimitedV2(const SampleSet& trainSet, const Sample& testSample,
		Distance* testSampleDists, Distance* testSampleNNdists, const int k);
	void findkNCNLimitedV2(const SampleSet& trainSet, const Sample& testSample);

	void learnMRobustRanks(SampleSet& trainSet);

	int assignLabel(const int testSampleIndex);
};