#include <stdio.h>
#include <string>

#include "Algorithm.h"

Algorithm::Algorithm(string name) {
    this->name = name;
    this->beatOutput = new vector<float>();
}

Algorithm::~Algorithm() {
    delete(this->beatOutput);
}

unsigned char * Algorithm::sampleData = NULL;
long Algorithm::sampleDataSize = 0;

void Algorithm::setSampleBuffer(unsigned char * buf, long size) {
	sampleData = buf;
	sampleDataSize = size;
}

long Algorithm::getSampleDataSize() { return Algorithm::sampleDataSize; }
unsigned char* Algorithm::getSampleData() { return Algorithm::sampleData; }

void Algorithm::cleanup() {
    delete(Algorithm::sampleData);
}
