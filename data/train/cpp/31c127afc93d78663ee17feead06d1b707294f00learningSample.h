/** 
* @file
* Declaration of LearningSample class - container for sample with assigned category
*/

/// Lukasz Rychter
/// Maciej Sikora


#ifndef __LEARNING_SAMPLE_H__
#define __LEARNING_SAMPLE_H__

#include <boost/smart_ptr/shared_ptr.hpp>
#include "fftSample.h"

namespace learn
{

template <typename LABEL=std::string>
class LearningSample
{
public:
	LearningSample() {} /// default constructor
	LearningSample(const boost::shared_ptr<media::FFTSample>& sample, const LABEL& category) : sample_(sample), category_(category) {} /// constructor that sets sample and cathegory

    void										setSample(const boost::shared_ptr<media::FFTSample>& sample) { sample_ = sample; } /// assigns sample
	const boost::shared_ptr<media::FFTSample>	getSample() const { return sample_; } /// accessor to the sample

	void										setCategory(const LABEL& category) { category_ = category; } /// assigns category
	const LABEL									getCategory() const { return category_; } /// accessor to the category

protected:
	boost::shared_ptr<media::FFTSample>	sample_;	/// smart pointer to the sample
	LABEL								category_;	///	 category assigned to the sample

};

} //namespace

#endif
