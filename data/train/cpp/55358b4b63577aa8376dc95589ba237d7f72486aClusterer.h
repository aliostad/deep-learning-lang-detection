#pragma once

#include "Sample.h"

class Clusterer {
public:
	Clusterer(int k);
	virtual ~Clusterer(void);
	// the sample should be normalized. L2 norm = 1.
	void addSample(const Sample& sample, float weight = 1.0);
	// the number of samples to be clustered.
	int sampleCount();
	// the center of the cluster.
	Sample center();
	Sample sample(size_t index) const;
	std::vector<int> labelArray() const;
	std::vector<Sample> sampleArray() const;
protected:
	// sample array
	std::vector<Sample> mSampleArray;
	// each sample has a weight
	std::vector<float> mWeightArray;
	// each sample has a clustering label
	std::vector<int> mLabelArray;
	// the number of clusters
	int mK;
};

