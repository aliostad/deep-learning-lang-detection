/*
 Copyright 2012 PettyFun Limited.  All rights reserved.
 */

#ifndef _PFSAMPLE_H_
#define _PFSAMPLE_H_

#include "PfChannel.h"

#define PF_SAMPLE_DEFAULT_OFFSET 0
#define PF_SAMPLE_DEFAULT_LENGTH 0
#define PF_SAMPLE_DEFAULT_MAX 10
#define PF_SAMPLE_DEFAULT_FLAGS 0

class PfSampleChannel;
class PfSample : public CIwManaged {
protected:
    HSAMPLE Sample;
    BASS_SAMPLE Info;
    CIwList<PfSampleChannel*> Channels;
public:
    IW_MANAGED_DECLARE(PfSample);
    PfSample(HSAMPLE sample, Json::Value settings) {
        Sample = sample;
        s3eBASS_SampleGetInfo(Sample, &Info);
    }
    BASS_SAMPLE GetInfo() {
        return Info;
    }
    PfSampleChannel* GetFreeChannel(bool onlyNew=false);
};

class PfSampleChannel : public PfChannel {
protected:
    PfSample* Sample;
public:
    PfSampleChannel(PfSample* sample, HCHANNEL channel) : PfChannel(channel) {
        Sample = sample;
    }
    bool SetPitch(float pitch);
};
#endif// _PFSAMPLE_H_
