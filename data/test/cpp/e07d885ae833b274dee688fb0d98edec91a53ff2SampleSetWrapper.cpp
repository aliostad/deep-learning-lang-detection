/**
 * @file SampleSetWrapper.cpp
 * @brief implements of SampleSetWrapper class
 *
 * @author S.Tanaka
 * @date 2008.01.07
 * 
 * Copyright(C) 2006-2014 Eisai Co., Ltd. All rights reserved.
 */


#include "stdafx.h"
#include "SampleSetWrapper.h"

#include "SampleWrapper.h"
#include "ClrObjectTool.h"


using namespace kome::clr;


#include <crtdbg.h>
#ifdef _DEBUG
    #define new new( _NORMAL_BLOCK, __FILE__, __LINE__ )
    #define malloc( s ) _malloc_dbg( s, _NORMAL_BLOCK, __FILE__, __LINE__ )
#endif    // _DEBUG



// constructor
SampleSetWrapper::SampleSetWrapper( kome::objects::SampleSet& sampleSet ) : m_sampleSet( sampleSet ) {
}

// destructor
SampleSetWrapper::~SampleSetWrapper() {
}

// get sample set object
kome::objects::SampleSet& SampleSetWrapper::getSampleSet() {
	return m_sampleSet;
}

// get sample set ID
int SampleSetWrapper::getSampleSetId() {
	return m_sampleSet.getSampleSetId();
}

// set file path
void SampleSetWrapper::setFilePath( System::String^ path ) {
	m_sampleSet.setFilePath( ClrObjectTool::convertString( path ).c_str() );
}

// get file path
System::String^ SampleSetWrapper::getFilePath() {
	return ClrObjectTool::convertString( m_sampleSet.getFilePath(), NULL );
}

// get file name
System::String^ SampleSetWrapper::getFileName() {
	return ClrObjectTool::convertString( m_sampleSet.getFileName(), NULL );
}

// judge whether sample set file is opened
bool SampleSetWrapper::isOpened() {
	return m_sampleSet.isOpened();
}

// clear samples
void SampleSetWrapper::clearSamples() {
	m_sampleSet.clearSamples();
}

// add sample
void SampleSetWrapper::addSample( SampleWrapper^ sample ) {
	// get sample
	kome::objects::Sample* s = NULL;
	if( sample != nullptr ) {
		s = &( sample->getSample() );
	}

	// add
	m_sampleSet.addSample( s );
}

// get the number of samples
unsigned int SampleSetWrapper::getNumberOfSamples() {
	return m_sampleSet.getNumberOfSamples();
}

// get sample
SampleWrapper^ SampleSetWrapper::getSample( unsigned int index ) {
	kome::objects::Sample* sample = m_sampleSet.getSample( index );
	SampleWrapper^ s = ClrObjectTool::createSampleWrapper( sample );

	return s;
}

// open file
bool SampleSetWrapper::openFile( System::String^ path ) {	
	std::string p = ClrObjectTool::convertString( path );
	return m_sampleSet.openFile( p.c_str() );
}

// close file
bool SampleSetWrapper::closeFile() {
	return m_sampleSet.closeFile();
}

// start loading timer
void SampleSetWrapper::startLoadingTimer() {
	kome::objects::SampleSet::startLoadingTimer();
}

// stop loading timer
void SampleSetWrapper::stopLoadingTimer() {
	kome::objects::SampleSet::stopLoadingTimer();
}

// get total loading timer
double SampleSetWrapper::getTotalLoadingTime() {
	return kome::objects::SampleSet::getTotalLoadingTime();
}
