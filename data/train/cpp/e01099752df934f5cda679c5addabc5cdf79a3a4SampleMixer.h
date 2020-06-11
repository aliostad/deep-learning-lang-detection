#ifndef _SAMPLE_MIXER_H_
#define _SAMPLE_MIXER_H_
/*
 *  SampleMixer.h
 *  Sin
 *
 *  Created by blucia0a on 8/6/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "SampleSource.h"
#define MIXER_MAX_SRCS 100
class SampleMixer : public SampleSource{

        unsigned numSources;
        SampleSource **srcs;
        float amp;
public:
        SampleMixer();
        bool Add(SampleSource *s);
        SampleSource *Remove(unsigned i);
	void Mix(int numSources, SampleSource **srcs, float *out);
        void getNextSample(float *out);
        void setAmpVal(float newamp);
};
#endif
