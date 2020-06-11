#ifndef __SAMPLE_H__
#define __SAMPLE_H__

#include <vector>
#include <iostream>
#include "sampler.h"

struct Sample {
    explicit Sample(float _x, float _y) : x(_x), y(_y) { }
    explicit Sample() : x(0), y(0) { }

    float x, y;
};

class SamplePacket {
public:
    explicit SamplePacket()
    {
        clear();
    }
    
    inline void addSample(float x, float y) {
        mSamples.emplace_back(x, y);
    }
    
    inline bool nextSample(const Sample*& s) {
        if (mCurrSample == mSamples.end()) return false;
        s = &(*mCurrSample);
        ++mCurrSample;
        return true;
    }
    
    inline void clear() {
        mSamples.clear();
        mSamples.reserve(Sampler::sSamplesPerPixel);
        mCurrSample = mSamples.begin();
    }
    
private:
    std::vector<Sample> mSamples;
    std::vector<Sample>::const_iterator mCurrSample;
};

#endif

