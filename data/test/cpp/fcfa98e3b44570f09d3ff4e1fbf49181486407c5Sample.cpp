#include "Sample.h"

namespace Common {

	//TODO: Add Comments
	
	Sample::Sample() : index(-1), label(-1), nrDims(0), dims(nullptr) {}

	Sample::Sample(const int i, const int l, const int n)
		: index(i), label(l), nrDims(n) {
		dims = allocateSampleDimsMemory(nrDims, __FILE__, __LINE__);
	}

	Sample::Sample(const int i, const int l, const int n, const SampleDim* sampleDimsArray)
		: index(i), label(l), nrDims(n) {
		dims = allocateSampleDimsMemory(nrDims, __FILE__, __LINE__);
		copySampleDims(sampleDimsArray, nrDims, dims);
	}

	Sample::~Sample() {
		freeSampleDimsMemory(dims, __FILE__, __LINE__);
	}

	Sample::Sample(const Sample& other) : index(other.index), label(other.label), nrDims(other.nrDims) {
		dims = allocateSampleDimsMemory(nrDims, __FILE__, __LINE__);
		copySampleDims(other.dims, other.nrDims, dims);
	}

	//SampleDim* Sample::getSampleDims() const {
	//	//TODO: should getter return shallow copy or deep copy?
	//	
	//	//float* result = new float[nrDims];
	//	//
	//	//for (int i = 0; i < nrDims; i++)
	//	//{
	//	//	result[i] = dims[i];
	//	//}

	//	//return result;
	//	return dims;
	//}

	//int Sample::getIndex() const { return index; }

	//int Sample::getLabel() const { return label; }

	//int Sample::getNrDims() const {	return nrDims; }

	//void Sample::setIndex(int i) { index = i; }

	//void Sample::setLabel(int l) { label = l; }

	//void Sample::setNrDims(int n) { nrDims = n; }

	Sample& Sample::operator=(const Sample& s) {
		if (this != &s)	{
			SampleDim* newSampleDims = allocateSampleDimsMemory(s.nrDims, __FILE__, __LINE__);
			copySampleDims(s.dims, s.nrDims, newSampleDims);
			freeSampleDimsMemory(dims, __FILE__, __LINE__);
			index = s.index;
			label = s.label;
			nrDims = s.nrDims;
			dims = newSampleDims;
		}

		return *this;
	}

	bool Sample::operator==(const Sample& s) const {
		if ((index != s.index) || (nrDims != s.nrDims) || (label != s.label)) { // can also compare on index
			return false;
		}
		if (dims[0] == s.dims[0]) {
			int dimIndex = 1;
			while (dimIndex < nrDims) {
				if (dims[dimIndex] != s.dims[dimIndex])
					return false;
				dimIndex++;
			}
			return true;
		}
		return false;
	}

	bool Sample::operator!=(const Sample& s) const {
		return !operator==(s);
	}

	SampleDim& Sample::operator[](int i) { return dims[i]; }

	const SampleDim& Sample::operator[](int i) const { return dims[i]; }

	//void Sample::swap(Sample& other) {
	//	using std::swap;
	//	swap(index, other.index);
	//	swap(label, other.label);
	//	swap(nrDims, other.nrDims);
	//	swap(dims, other.dims);
	//}   

	void Sample::copySampleDims(const SampleDim* src, int nrDims, SampleDim* dst) {
		size_t size = (nrDims) * sizeof(SampleDim);
		memcpy(dst, src, size);
	}

	std::ostream& operator<<(std::ostream& out, const Sample& s) {
		return out << s.dims << " " << s.index << " " << s.label << " " << s.nrDims;
	}

	void swapSamples(Sample& s1, Sample& s2) {
		Sample tempSample(s1);
		s1 = s2;
		s2 = tempSample;
	}
				
}