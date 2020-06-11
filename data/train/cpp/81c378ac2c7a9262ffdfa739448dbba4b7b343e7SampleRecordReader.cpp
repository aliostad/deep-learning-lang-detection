#include <stdint.h>
#include <fstream>
#include "iterator"

#include "SampleRecordReader.h"

using namespace std;

SampleRecordReader::SampleRecordReader() {
}

SampleRecordReader::~SampleRecordReader() {
}

vector<Sample> SampleRecordReader::read(istream& is) {
	int32_t sampleRecordCount;
	readLE(is, &sampleRecordCount);

	vector<Sample> sampleRecords(sampleRecordCount);

	for (int32_t i = 0; i < sampleRecordCount; ++i) {
		read(is, sampleRecords[i]);
	}

	return sampleRecords;
}

istream& SampleRecordReader::read(istream& is, Sample& sampleRecord) const {
	readLE(is, &sampleRecord.ifovId);
	readLE(is, &sampleRecord.randomNumber);
	readLE(is, &sampleRecord.ifovInEfovIndex);
	readLE(is, &sampleRecord.lat);
	readLE(is, &sampleRecord.lon);
	readLE(is, &sampleRecord.month);
	readLE(is, &sampleRecord.cloudType);
	readLE(is, &sampleRecord.ifovValid);
	readLE(is, &sampleRecord.efovValid);
	readLE(is, &sampleRecord.elevatedPolarRegion);
	readLE(is, &sampleRecord.desertRegion);
	readLE(is, &sampleRecord.dustStorm);
	readLE(is, &sampleRecord.fractionalLandCover);

	for (size_t i = 0; i < sampleRecord.brightnessTemperatures.size(); ++i) {
		int32_t count;
		readLE(is, &count);

		sampleRecord.brightnessTemperatures[i].resize(count);
		readLE(is, &sampleRecord.brightnessTemperatures[i][0], count);
	}

	return is;
}
