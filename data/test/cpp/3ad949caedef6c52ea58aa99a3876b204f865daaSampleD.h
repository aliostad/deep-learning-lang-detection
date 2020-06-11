/*
 * SampleD.h
 *
 *  Created on: Sep 6, 2014
 *      Author: Edward
 */

#ifndef SAMPLED_H_
#define SAMPLED_H_

#include <string>
#include <vector>

class SampleD {
public:
	SampleD(const SampleD &sd);
	SampleD(unsigned int size_d = 0, uint8_t lbl = 0);
	virtual ~SampleD();
	unsigned int size();
	//void squared();
	void operator=(const SampleD &sd);
	void operator=(SampleD &&sd);
	void operator=(const double val);
	void operator+=(const SampleD &sd);
	void operator+=(const double val);
	void operator*=(const double val);
	friend std::ostream& operator<<(std::ostream& os, const SampleD& sample);
	double distance(const SampleD &s);
	static void sum_and_square(SampleD &s, SampleD &sum, SampleD &square);
	static void mean_and_variance(const unsigned int n, const SampleD &sum, const SampleD &square, SampleD &mean, SampleD &variance);
	static double likelihood(const SampleD &x, const SampleD &mean, const SampleD &variance);
	static void loadSamplesFromMatrix(std::string sample_filename, std::string label_filename, std::vector<SampleD> &v);
	uint8_t label;
private:
	std::vector<double> data;
	static const double epsilon;
};

#endif /* SAMPLED_H_ */
