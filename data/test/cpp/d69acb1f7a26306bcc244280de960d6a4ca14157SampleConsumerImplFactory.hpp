#ifndef VIDEO_CAPTURE_SAMPLE_CONSUMER_IMPL_FACTORY_H
#define VIDEO_CAPTURE_SAMPLE_CONSUMER_IMPL_FACTORY_H

#include "SampleConsumerImpl.hpp"

namespace VideoCapture {

template<typename Sample> class SampleConsumerImplFactory {
 public:
  typedef Sample SampleType;
  typedef SampleType& SampleRef;
  typedef SampleConsumerImpl<SampleType> SampleConsumerImplType;
  typedef typename SampleConsumerImplType::SampleConsumerCallback
  SampleConsumerCallback;
  typedef typename SampleConsumerImplType::SampleSinkType SampleSinkType;
  typedef SampleConsumerImplType ProcessorType;

  SampleConsumerImplFactory(
      const SampleSinkType& sampleSink,
      const SampleConsumerCallback& sampleConsumerCallback)
      : m_sampleSink(sampleSink),
        m_sampleConsumerCallback(sampleConsumerCallback) {

  }

  SampleConsumerImplType createSampleConsumer() const {
    SampleConsumerImplType sampleConsumer(
        m_sampleSink,
        m_sampleConsumerCallback);
    return sampleConsumer;
  }

  SampleConsumerImplType operator()() const {
    return createSampleConsumer();
  }

 private:
  SampleSinkType m_sampleSink;
  SampleConsumerCallback m_sampleConsumerCallback;
};

} // VideoCapture

#endif // VIDEO_CAPTURE_SAMPLE_CONSUMER_IMPL_FACTORY_H
