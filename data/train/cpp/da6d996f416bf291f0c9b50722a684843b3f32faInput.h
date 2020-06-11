//
//  Input.h
//  TheMeasuresTaken
//
//  Created by Ali Nakipoğlu on 6/4/13.
//
//

#pragma once

#include "ofMain.h"
#include "Params.h"
#include "ofxMSAControlFreak.h"


template<typename T>
class InputSample
{
    
public:
    
    InputSample()
    {};
    
    ~InputSample(){};
    
public:
    
    void setSampleID( const int sampleID_ )
    {
        sampleID    = sampleID_;
    };
    
    void setSample( const T & sample_ )
    {
        sample  = sample_;
    };
    
    const int & getSampleID() const
    {
        return sampleID;
    };
    
    const T & getSample() const
    {
        return sample;
    };
    
private:
    
    int     sampleID;
    T       sample;
};

typedef InputSample<ofPoint>  PointInputSampleT;

class Input
{
    
public:
    
    msa::controlfreak::ParameterGroup params;
    
    std::map< msa::controlfreak::Parameter*, std::pair<int, int> >  midiMappings;
    std::map< msa::controlfreak::Parameter*, std::string >          oscMappings;
    
    Input(){};
    virtual ~Input(){};
    
public:
    
    virtual void update(){};
    virtual const vector<PointInputSampleT> & getSamples() const {};
    virtual const vector<ofPolyline>& getPolys() const {};
};
