#pragma once
#include "stdafx.h"



struct WrappedSample;

class KNN
{

	static arma::fmat metric;


public:
	KNN();

	static float mDistance(const WrappedSample x, const WrappedSample y);

	void Load(std::vector<WrappedSample>& training);

	void Rebuild(arma::fmat newM);

	//Gets K nearest targets
	void GetTargetNeighbours(WrappedSample& sample, WrappedSample targets[]);
	//Get all impostors not in the safe zone
	void GetImpostors(WrappedSample& sample, float range, std::vector<WrappedSample>& impostors);
	~KNN();
};

