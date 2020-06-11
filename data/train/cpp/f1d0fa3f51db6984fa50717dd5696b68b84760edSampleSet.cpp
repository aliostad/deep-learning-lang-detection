/********************************************************************
	Rhapsody	: 7.5 
	Login		: KBE
	Component	: TargetComponent 
	Configuration 	: Target
	Model Element	: SampleSet
//!	Generated Date	: Sat, 15, May 2010  
	File Path	: C:/Ubuntu_share/sapien190/source/Sandbox/sapine_v1/rpy/SampleSet.cpp
*********************************************************************/

//## auto_generated
#include "SampleSet.h"
//## package Application::Continuous

//## class SampleSet
SampleSet::SampleSet() : num(2) {
}

SampleSet::~SampleSet() {
}

Sample* SampleSet::GetSample(int idx) {
    //#[ operation GetSample(int)
    if (idx < num)
    	return &itsSample[idx];
    else
    	return 0;
    //#]
}

int SampleSet::getItsSample() const {
    int iter = 0;
    return iter;
}

void SampleSet::SetSample(int idx, const Sample& sample) {
    //#[ operation SetSample(int,Sample)
    if (idx < num)
    	itsSample[idx] = sample;
    //#]
}

int SampleSet::getNum() const {
    return num;
}

void SampleSet::setNum(int p_num) {
    num = p_num;
}

WFDB_Annotation SampleSet::GetAnnotation() {
    //#[ operation GetAnnotation()
    return annotation;
     
    //#]
}

void SampleSet::SetSample(int idx, WFDB_Sample value) {
    //#[ operation SetSample(int,WFDB_Sample)
    if (idx < num)
    {
    	itsSample[idx].setValue(value);
    }
    //#]
}

void SampleSet::SetAnnotation(WFDB_Annotation _annotation) {
    //#[ operation SetAnnotation(WFDB_Annotation)
    annotation = _annotation;
    
    //#]
}

void SampleSet::SetSample(int idx, WFDB_Sample value, WFDB_Annotation ann) {
    //#[ operation SetSample(int,WFDB_Sample,WFDB_Annotation)
    if (idx < num)
    {
    	itsSample[idx].setValue(value);
       	SetAnnotation(ann);
    }
    //#]
}

WFDB_Sample SampleSet::GetSampleValue(int idx) {
    //#[ operation GetSampleValue(int)
    if (idx < num)
    	return itsSample[idx].getValue();
    else
    	return 0;
    //#]
}

WFDB_Time SampleSet::GetSampleID() {
    //#[ operation GetSampleID()
    return sampleID;
    
    //#]
}

void SampleSet::SetSampleID(WFDB_Time _sampleID) {
    //#[ operation SetSampleID(WFDB_Time)
    sampleID = _sampleID;
    
    //#]
}

WFDB_Annotation SampleSet::FactoryAnnotation(char anntyp) {
    //#[ operation FactoryAnnotation(char)
    WFDB_Annotation ann;
    ann.time = 0;
    ann.anntyp = anntyp;
    ann.subtyp = 0;
    ann.chan  = 0; 
    ann.num = 0;
    ann.aux = 0; 
    return ann;
    //#]
}

WFDB_Annotation SampleSet::getAnnotation() const {
    return annotation;
}

void SampleSet::setAnnotation(WFDB_Annotation p_annotation) {
    annotation = p_annotation;
}

WFDB_Time SampleSet::getSampleID() const {
    return sampleID;
}

void SampleSet::setSampleID(WFDB_Time p_sampleID) {
    sampleID = p_sampleID;
}

/*********************************************************************
	File Path	: C:/Ubuntu_share/sapien190/source/Sandbox/sapine_v1/rpy/SampleSet.cpp
*********************************************************************/
