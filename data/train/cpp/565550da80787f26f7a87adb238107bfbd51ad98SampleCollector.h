#ifndef SAMPLE_COLLECTOR_H_
#define SAMPLE_COLLECTOR_H_

#include <vector>

#include "CloudTest.h"
#include "Enums.h"

class SampleCollector {
public:
	/**
	 * Constructor.
	 * 
	 * @param trainingFraction the fractional size of the training dataset.
	 */
	SampleCollector(DatasetId datasetId, double trainingFraction = 2.0 / 3.0);

	/**
	 * Destructor.
	 */
	~SampleCollector() {
	}

	SampleList collectSamples(const CloudTest& cloudTest) const;

	static std::vector<Sample> getSamples() {
		return SAMPLES;
	}
	
private:
	SampleList dataset;

	static const std::vector<Sample> SAMPLES;
};

#endif /*SAMPLE_COLLECTOR_H_*/
