/**
 * @file ClrSample.cpp
 * @brief implements of ClrSample class
 *
 * @author S.Tanaka
 * @date 2008.01.07
 * 
 * Copyright(C) 2006-2014 Eisai Co., Ltd. All rights reserved.
 */


#include "stdafx.h"
#include "ClrSample.h"

#include "SampleSetWrapper.h"
#include "ClrSampleBase.h"
#include "ClrObjectPool.h"

#include "DataGroupNodeWrapper.h"
#include "SpectrumWrapper.h"
#include "PeaksWrapper.h"
#include "CLRObjectTool.h"
#include "ProgressWrapper.h"

using namespace kome::clr;


#include <crtdbg.h>
#ifdef _DEBUG
    #define new new( _NORMAL_BLOCK, __FILE__, __LINE__ )
    #define malloc( s ) _malloc_dbg( s, _NORMAL_BLOCK, __FILE__, __LINE__ )
#endif    // _DEBUG



// constructor
ClrSample::ClrSample( SampleSetWrapper^ sampleSet )
		: kome::objects::Sample( sampleSet == nullptr ? NULL : &( sampleSet->getSampleSet() ) ) {
}

// destructor
ClrSample::~ClrSample() {
	ClrObjectPool::getInstance().removeSample( *this );
	m_baseSample = nullptr;
}

// set base sample
void ClrSample::setBaseSample( ClrSampleBase^ baseSample ) {
	m_baseSample = baseSample;
}

// get base sample
ClrSampleBase^ ClrSample::getBaseSample() {
	ClrSampleBase^ baseSample = m_baseSample;
	return baseSample;
}

// on detect peaks by API
void ClrSample::onDetectPeaksByAPI( kome::objects::Spectrum* spec, kome::objects::Peaks* peaks ) {
	// base sample
	ClrSampleBase^ baseSample = m_baseSample;
	if( baseSample == nullptr ) {
		return;
	}

	// detect peaks
	SpectrumWrapper^ s = ClrObjectTool::createSpectrumWrapper( spec );
	PeaksWrapper^ p = ClrObjectTool::createPeaksWrapper( peaks );
	baseSample->onDetectPeaksByAPI( s, p );		
}

// on open
bool ClrSample::onOpenSample( kome::objects::DataGroupNode* rootGroup, kome::core::Progress* progress ) {
	// base sample
	ClrSampleBase^ baseSample = m_baseSample;
	if( baseSample == nullptr ) {
		return false;
	}

	// root group
	DataGroupNodeWrapper^ g = nullptr;
	if( rootGroup != NULL ) {
		g = gcnew DataGroupNodeWrapper( *rootGroup );
	}

	// open
	return baseSample->onOpenSample( g );
}

// on close
bool ClrSample::onCloseSample() {
	// base sample
	ClrSampleBase^ baseSample = m_baseSample;
	if( baseSample == nullptr ) {
		return false;
	}

	// close
	return baseSample->onCloseSample();
}
