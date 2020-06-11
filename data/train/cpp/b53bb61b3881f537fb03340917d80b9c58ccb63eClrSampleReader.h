/**
 * @file ClrSampleReader.h
 * @brief Clr Sample Reader
 * @author OKADA, H.
 * @date 2012/07/18
 * Copyright (C) 2014 Shimadzu Corporation All rights reserved.
 */


#ifndef _CLR_SAMPLE_READER_
#define _CLR_SAMPLE_READER_

#include "stdafx.h"
#include "ClrSampleReaderBase.h"
#include "SampleReaderWrapper.h"	// @date 2012/08/22 <Add> OKADA

namespace kome {
	namespace clr {
		
		/** 
		 * @class ClrSampleReader
		 * @ brief Clr Sample Reader class
		 */
		class ClrSampleReader : public kome::objects::SampleReader{
			
		public:
			/**
			 * @fn ClrSampleReader();
			 * @brief constructor
			 */
			ClrSampleReader();
			
			/**
			 * @fn ~ClrSampleReader();
			 * @brief destructor
			 */
			virtual ~ClrSampleReader();

			/**
			 * @fn void setBaseSampleReader( ClrSampleReaderBase^ baseSampleReader )
			 * @brief set the base sample reader
			 * @param[in] baseSampleReader ClrSampleReaderBase object
			 */
			void setBaseSampleReader( ClrSampleReaderBase^ baseSampleReader );	// @date 2012/08/22 <Add> OKADA

			/**
			 * @fn kome::clr::ClrSampleReaderBase^ ClrSampleReader::getBaseSampleReader()
			 * @brief get the base sample reader
			 * @return ClrSampleReaderBase object
			 */
			kome::clr::ClrSampleReaderBase^ getBaseSampleReader();						// @date 2012/08/22 <Add> OKADA

		private:
			/** base sample reader objec */
			gcroot <ClrSampleReaderBase ^> m_baseSampleReader;

		protected:

			/**
			 * @fn std::string onSelectKeys( void )
			 * @brief call onSelectKeys
			 */
			std::string onSelectKeys( void );

			
			/**
			 * @fn kome::objects::Sample* onOpenData( std::string strKey )
			 * @brief cakk onOpenData
			 * @param strKey
			 * @return Opened sample
			 */
			kome::objects::Sample* onOpenData( std::string strKey );

		};
	}
}


#endif
