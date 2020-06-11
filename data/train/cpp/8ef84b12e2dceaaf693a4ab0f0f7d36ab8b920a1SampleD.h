/*
 * SampleD.h
 *
 *  Created on: Sep 6, 2014
 *      Author: Edward
 */

#ifndef SAMPLED_H_
#define SAMPLED_H_

#include "Sample.h"

class SampleD {
public:
	SampleD(const SampleD &sd);
	SampleD(unsigned int size_d = 0);
	SampleD(const Sample& s);
	virtual ~SampleD();
	void squared();
	void operator=(const SampleD &sd);
	void operator=(SampleD &&sd);
	void operator=(const Sample &s);
	void operator=(const double val);
	void operator+=(const SampleD &sd);
	void operator+=(const Sample &s);
	void operator+=(const double val);
	void operator*=(const double val);
	static void sum_and_square(Sample &s, SampleD &sum, SampleD &square);
	static void mean_and_variance(const unsigned int n, const SampleD &sum, const SampleD &square, SampleD &mean, SampleD &variance);
	static double likelihood(const Sample &x, const SampleD &mean, const SampleD &variance);
private:
	std::vector<double> data;
	static const double epsilon;
};

#endif /* SAMPLED_H_ */
