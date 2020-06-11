#include "Clusterer.h"

Clusterer::Clusterer(int k) :
		mK(k) {
}

Clusterer::~Clusterer(void) {
}

void Clusterer::addSample(const Sample& sample, float weight) {
	mSampleArray.push_back(sample);
	mWeightArray.push_back(weight);
}

Sample Clusterer::center(){
	if(mSampleArray.empty()){
		return Sample(0);
	}
	int sampleSize=(int)mSampleArray[0].size();
	std::vector<float> centerSample(sampleSize,0.0f);
	for(size_t i=0;i<mSampleArray.size();++i){
		for(int j=0;j<sampleSize;++j){
			centerSample[j]+=mSampleArray[i][j];
		}
	}
	for(int j=0;j<sampleSize;++j){
		centerSample[j]/=(float)mSampleArray.size();
	}
	return Sample(centerSample);
}

int Clusterer::sampleCount() {
	return (int) mSampleArray.size();
}

Sample Clusterer::sample(size_t index) const {
	if (index < mSampleArray.size()) {
		return mSampleArray[index];
	}
	std::cerr << "Out of boundary" << std::endl;
	exit(1);
}

std::vector<int> Clusterer::labelArray() const {
	return mLabelArray;
}

std::vector<Sample> Clusterer::sampleArray() const{
	return mSampleArray;
}