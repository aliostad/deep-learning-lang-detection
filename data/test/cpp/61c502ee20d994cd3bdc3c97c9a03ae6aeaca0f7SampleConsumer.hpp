#ifndef VIDEO_CAPTURE_SAMPLE_CONSUMER_H
#define VIDEO_CAPTURE_SAMPLE_CONSUMER_H

#include "boost/shared_ptr.hpp"
#include "ProcessorThread.hpp"
#include "SampleConsumerImplFactory.hpp"

namespace VideoCapture {

template<typename Sample> class SampleConsumer {
 public:
  typedef Sample SampleType;
  typedef SampleConsumerImplFactory<SampleType> SampleConsumerImplFactoryType;
  typedef ProcessorThread<SampleConsumerImplFactoryType> ProcessorThreadType;
  typedef boost::shared_ptr<ProcessorThreadType> ProcessorThreadSharedPtr;
  typedef SampleConsumerImpl<SampleType> SampleConsumerImplType;
  typedef typename SampleConsumerImplType::SampleConsumerCallback
  SampleConsumerCallback;
  typedef typename SampleConsumerImplType::SampleSinkType SampleSinkType;

  SampleConsumer() {

  }

  SampleConsumer(const ProcessorThreadSharedPtr& pProcessorThread)
      : m_pProcessorThread(pProcessorThread) {

  }

 private:
  ProcessorThreadSharedPtr m_pProcessorThread;
};

} // VideoCapture

#endif // VIDEO_CAPTURE_SAMPLE_CONSUMER_H
