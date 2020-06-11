#ifndef __PERFORMANCEMONOTOR_H__
#define __PERFORMANCEMONITOR_H__

#include "pammo.h"
#include <string>

namespace pammo
{

class PerformanceMonitor
{
public:
    PerformanceMonitor(char const* name, uint32_t reportFrequency)
    {
        mName = name;
        mReportFrequency = reportFrequency;
        reset();
    }

    virtual ~PerformanceMonitor(){}

    void reset()
    {
        mSampleCount = 0;
        mSampleMin = 0xFFFFFFFF;
        mSampleMax = 0;
        mSampleAve = 0;
    }

    void addSample(float n)
    {
        ++mSampleCount;

        if(n < mSampleMin)
            mSampleMin = n;

        if(n > mSampleMax)
            mSampleMax = n;

        float beta = 0.1;
        mSampleAve = mSampleAve * (1.0 - beta) + (n* beta);

        if(!(mSampleCount%mReportFrequency))
        {
            report();
            reset();
        }
    }
    void report()
    {
        dprintf("%s\nmin\tmax\tave\n%.2f\t%.2f\t%.2f\n", 
            mName.c_str(), mSampleMin, mSampleMax, mSampleAve);
    }

protected:

private:
    std::string mName;
    uint32_t mReportFrequency;
    
    float mSampleAve;
    uint32_t mSampleCount;
    float mSampleMax;
    float mSampleMin;
};

} // namespace pammo

#endif // __PERFORMANCEMONITOR_H__