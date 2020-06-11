/*
 * IBiometricSample.h
 *
 *  Created on: 23.1.2014
 *      Author: JV
 */

#ifndef IBIOMETRICSAMPLELOADER_H_
#define IBIOMETRICSAMPLELOADER_H_
#include <memory>

namespace BioFW {

	template <class TDbRecord, class TBiometricSample>
    class IBiometricSampleLoader {
    	public:
			typedef std::shared_ptr <IBiometricSampleLoader> Ptr;
			typedef TDbRecord Record;
			typedef TBiometricSample Sample;

			virtual ~IBiometricSampleLoader(){

    		}
			virtual TBiometricSample createBiometricSample(const TDbRecord & record) = 0;
    };

}  // namespace BioFW


#endif /* IBIOMETRICSAMPLE_H_ */
