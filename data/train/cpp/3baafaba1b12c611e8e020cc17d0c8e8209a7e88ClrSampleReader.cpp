/**
* @file ClrSampleReader.cpp
* @brief Clr Sample Reader
* @author OKADA, H.
* @date 2012/07/18
* Copyright (C) 2014 Shimadzu Corporation All rights reserved.
* <補足説明>
*/


#include "ClrSampleReader.h"
#include "ClrObjectTool.h"
#include "ClrObjectPool.h"

using kome::clr::ClrSampleReader;


// constructor
ClrSampleReader::ClrSampleReader(){
}

// destructor
ClrSampleReader::~ClrSampleReader(){
	ClrObjectPool::getInstance().removeSampleReader( *this );	// @date 2013/01/16 <Add> OKADA
	m_baseSampleReader = nullptr;								// @date 2013/01/16 <Add> OKADA
}


void ClrSampleReader::setBaseSampleReader( kome::clr::ClrSampleReaderBase^ baseSampleReader ){
	m_baseSampleReader = baseSampleReader;
}


kome::clr::ClrSampleReaderBase^ ClrSampleReader::getBaseSampleReader(){
	return m_baseSampleReader;
}

// ClrSampleReaderBase の onSelectKeysを呼び出す。
std::string ClrSampleReader::onSelectKeys( void ){
	ClrSampleReaderBase^ baseSampleReader = m_baseSampleReader;

	if( dynamic_cast<ClrSampleReaderBase^>(baseSampleReader) == nullptr )
	{
		return "";
	}
	
	return ClrObjectTool::convertString( baseSampleReader->onSelectKeys() );

};

// ClrSampleReaderBase の onOpenData を呼び出す
kome::objects::Sample* ClrSampleReader::onOpenData( std::string strKey ){
	ClrSampleReaderBase^ baseSampleReader = m_baseSampleReader;
	SampleWrapper^ sample = baseSampleReader->onOpenData( ClrObjectTool::convertString( strKey.c_str(), "" ) );
	kome::objects::Sample* s = ClrObjectTool::getSample( sample );
	
	return s;
};

