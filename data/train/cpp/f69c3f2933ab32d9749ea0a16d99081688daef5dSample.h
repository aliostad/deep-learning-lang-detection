/*
 * Sample.h
 *
 *  Created on: Aug 26, 2014
 *      Author: Edward
 */

#ifndef SAMPLE_H_
#define SAMPLE_H_

#include <iostream>
#include <vector>
#include <string>
#include <stdint.h>

class SampleD;

class Sample {
	friend class SampleD;
public:
	Sample();
	Sample(uint32_t width_t, uint32_t height_t, uint8_t lbl=0);
	virtual ~Sample();
	double distance(Sample &s);
	friend std::ostream& operator<<(std::ostream& os, const Sample& sample);
	static void loadSamples(std::string sample_filename, std::string label_filename, std::vector<Sample> &v);
	uint8_t label;
protected:
	uint32_t width;
	uint32_t height;
	std::vector<double> data;
};

#endif /* SAMPLE_H_ */
