#ifndef INCLUDED_BASICSAMPLERATEFREQUENCYPHASEESSENCE_H
#define INCLUDED_BASICSAMPLERATEFREQUENCYPHASEESSENCE_H

class BasicSampleRateFrequencyPhaseEssence{
public:
    BasicSampleRateFrequencyPhaseEssence( double sampleRate=44100., float frequency=440., double phase=0. )
        : sampleRate_( sampleRate ), frequency_(frequency), phase_(phase) {}


    BasicSampleRateFrequencyPhaseEssence& sampleRate( double x )
        { sampleRate_ = x; return *this; }
        
    BasicSampleRateFrequencyPhaseEssence& frequency( float x )
        { frequency_ = x; return *this; }

    BasicSampleRateFrequencyPhaseEssence& phase( float x )
        { phase_ = x; return *this; }


    void getSampleRateFrequencyPhase( double& sampleRate, float& frequency, float& phase ) {
        sampleRate = sampleRate_;
        frequency = frequency_;
        phase = phase_;
    }

private:
    double sampleRate_;
    float frequency_;
    float phase_;
};

#endif /* INCLUDED_BASICSAMPLERATEFREQUENCYPHASEESSENCE_H */
