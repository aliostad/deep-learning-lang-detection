/**
 * @file SampleMergeManager.h
 * @brief interfaces of SampleMergeManager class
 *
 * @author S.Tanaka
 * @date 2009.03.03
 * 
 * Copyright(C) 2006-2014 Eisai Co., Ltd. All rights reserved.
 */


#ifndef __KOME_SAMPLE_MERGE_MANAGER_H__
#define __KOME_SAMPLE_MERGE_MANAGER_H__


namespace kome {
	namespace merged {

		class MergedSampleSet;

		/**
		 * @class SampleMergeManager
		 * @brief merged management class
		 */
		class SampleMergeManager : public kome::objects::DefaultDataManager {
		protected:
			/**
			 * @fn SampleMergeManager()
			 * @brief constructor
			 */
			SampleMergeManager();

			/**
			 * @fn virtual ~SampleMergeManager()
			 * @brief destructor
			 */
			virtual ~SampleMergeManager();

		protected:
			/** merged sample ID */
			unsigned int m_id;

			/** merged sample sets */
			std::vector< MergedSampleSet* > m_sampleSets;
		
		public:
			/**
			 * @fn void addSampleSet( MergedSampleSet* sampleSet )
			 * @brief adds sample set
			 * @param sampleSet sample set object to be added
			 */
			void addSampleSet( MergedSampleSet* sampleSet );

			/**
			 * @fn void removeSampleSet( MergedSampleSet* sampleSet )
			 * @brief removes sample set
			 * @param sampleSet sample set object to be removed
			 */
			void removeSampleSet( MergedSampleSet* sampleSet );
						
		public:
			/**
			 * @fn unsigned int getNextId()
			 * @brief gets next merged sample ID
			 */
			unsigned int getNextId();

		protected:
			/**
			 * @fn virtual void onCloseSample( kome::objects::Sample* sample, const bool deleting )
			 * @brief This method is called when a sample is closed. (override method)
			 * @param sample sample object to be closed
			 * @param[in] deleting If true, the specified object is being deleted now.
			 */
			virtual void onCloseSample( kome::objects::Sample* sample, const bool deleting );

		public:
			/**
			 * @fn static SampleMergeManager& getInstance()
			 * @brief gets merged manager object
			 * @return merged manager object (This is the only object.)
			 */
			static SampleMergeManager& getInstance();
		};
	}
}

#endif		// __KOME_SAMPLE_MERGE_MANAGER_H__
