/********************************************************************
	Rhapsody	: 7.5 
	Login		: KBE
	Component	: TargetComponent 
	Configuration 	: Target
	Model Element	: SampleSet
//!	Generated Date	: Thu, 13, May 2010  
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

WFDB_Annotation SampleSet::GetAnnotation(int idx) {
    //#[ operation GetAnnotation(int)
    
     if (idx < num)
    	return itsSample[idx].getAnnotation();
     else 
     	return Sample::FactoryAnnotation(NOTQRS);
     
    //#]
}

void SampleSet::SetSample(int idx, WFDB_Sample value) {
    //#[ operation SetSample(int,WFDB_Sample)
    if (idx < num)
    {
    	itsSample[idx].setValue(value);
    	itsSample[idx].setAnnotation(Sample::FactoryAnnotation(NORMAL));
    }
    //#]
}

void SampleSet::SetAnnotation(int idx, WFDB_Annotation annotation) {
    //#[ operation SetAnnotation(int,WFDB_Annotation)
     if (idx < num)
    	itsSample[idx].setAnnotation(annotation);
    //#]
}

void SampleSet::SetSample(int idx, WFDB_Sample value, WFDB_Annotation ann) {
    //#[ operation SetSample(int,WFDB_Sample,WFDB_Annotation)
    if (idx < num)
    {
    	itsSample[idx].setValue(value);
    	itsSample[idx].setAnnotation(ann);
    }
    //#]
}

WFDB_Annotation SampleSet::getAnnotation() const {
    return annotation;
}

void SampleSet::setAnnotation(WFDB_Annotation p_annotation) {
    annotation = p_annotation;
}

/*********************************************************************
	File Path	: C:/Ubuntu_share/sapien190/source/Sandbox/sapine_v1/rpy/SampleSet.cpp
*********************************************************************/
