#include "Sample.h"

Sample::Sample(unsigned size) : V(size) {}

Sample::~Sample(void) {}

double Sample::Mean(void) {
	double result = 0;
	for (unsigned i=0; i<_size; i++)
		result+=Get(i);
	result/=_size;
	return result;
}

double Sample::MeanSq(void) {
	Sample s2(0);
	for (unsigned i=0; i<_size; i++) {
		double s1 = Get(i);
		s2.Push(s1*s1);
	}
	return s2.Mean();

}

double Sample::Variance(void) {
	return MeanSq()-Mean()*Mean();
}

double Sample::VarianceCorrected(void) {
	return (double(_size)/double(_size-1))*Variance();
}