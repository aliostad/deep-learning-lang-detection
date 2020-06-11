#include <stdint.h>
#include <cstdlib>
#include <string>

#include "SampleCollector.h"
#include "SampleRecordReader.h"
#include "FilePathResolver.h"

using namespace std;

SampleCollector::SampleCollector(DatasetId datasetId, double trainingFraction) {
	for (size_t i = 0; i < SAMPLES.size(); ++i) {
		const Sample& sample = SAMPLES[i];

		if (datasetId == TRAINING) {
			if (sample.getRandomNumber() < trainingFraction) {
				dataset.push_back(&sample);
			}
		} else {
			if (sample.getRandomNumber() > trainingFraction) {
				dataset.push_back(&sample);
			}
		}
	}
}

SampleList SampleCollector::collectSamples(const CloudTest& cloudTest) const {
	SampleList samples;

	for (size_t i = 0; i < dataset.size(); ++i) {
		const Sample* sample = dataset[i];

		if (cloudTest.accept(*sample) && cloudTest.select(*sample)) {
			samples.push_back(sample);
		}
	}

	return samples;
}

static const string getenv(const string& name, const string& defaultValue) {
	const char* value = getenv(name.c_str());

	if (value == 0) {
		return defaultValue;
	}

	return string(value);
}

const vector<Sample>
		SampleCollector::SAMPLES =
				SampleRecordReader().AbstractDataReader<std::vector<Sample> >::read(FilePathResolver::getAbsolutePath(getenv("IAVISA_DATA", "optdata/IAVISA_SAMPLES_CLDTST_OPT")).c_str());
