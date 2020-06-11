#include "Sample.h"

Sample::Sample(int _timeWindow, int _sampleId, int _size)
{
	timeWindow = _timeWindow;
	sampleId = _sampleId;
	size = _size;
	data = 0;
	occupancy = 0;
}

Sample::Sample()
{
	timeWindow = 0;
	sampleId = 0;
	size = 0;
	data = 0;
	occupancy = 0;
}

Sample::Sample(int _timeWindow, int _sampleId, int _size, int _data)
{
	timeWindow = _timeWindow;
	sampleId = _sampleId;
	size = _size;
	data = _data;
	occupancy = 0;
}

Sample::Sample(int _timeWindow, int _sampleId, int _size, int _data, int _occupancy)
{
	timeWindow = _timeWindow;
	sampleId = _sampleId;
	size = _size;
	data = _data;
	occupancy = _occupancy;
}

Sample& Sample::operator = (const Sample& _sample) {
	timeWindow = _sample.timeWindow;
	sampleId = _sample.sampleId;
	size = _sample.size;
	data = _sample.data;
	occupancy = _sample.occupancy;
	return *this;
}
