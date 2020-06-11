#ifndef TOMATL_STREAM_PROPERTIES
#define TOMATL_STREAM_PROPERTIES

#include <cmath>

class StreamProperties
{
public:
	StreamProperties(void) : m_sampleRate(0.0)
	{

	}

	double toDb(double sample)
	{
		return fabs(6 * (log(sample) / log2()));
	}

	double toSampleVal(double db)
	{
		return pow(2, db / 6);
	}

	double toMsec(double sampleCount)
	{
		return sampleCount / this->getSampleRate() * 1000;
	}

	double toSampleCnt(double msec)
	{
		return this->getSampleRate() / 1000 * msec;
	}

	double getSampleRate(void)
	{
		return m_sampleRate;
	}

	StreamProperties& setSampleRate(double srate)
	{
		m_sampleRate = srate;

		return *this;
	}
	
	static const double pi()
	{
		return 3.1415926535897932384626433832795;
	}

	static const double log2()
	{
		return 0.30102999566398119521373889472449;
	}

private:
	double m_sampleRate;
};

#endif