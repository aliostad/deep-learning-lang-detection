#ifndef VIDEO_CAPTURE_RECYCLING_SAMPLE_QUEUE_PAIR_H
#define VIDEO_CAPTURE_RECYCLING_SAMPLE_QUEUE_PAIR_H

#include "boost/shared_ptr.hpp"
#include "SampleQueue.hpp"
#include "SampleQueueImpl.hpp"
#include "ThreadSafeSampleQueueImpl.hpp"

namespace VideoCapture {

template<typename Sample> class RecyclingSampleQueuePair {
 public:
  typedef Sample SampleType;
  typedef SampleQueue<SampleType> SampleQueueType;
  typedef boost::shared_ptr<SampleQueueType> SampleQueueSharedPtr;

  RecyclingSampleQueuePair() {

  }

  RecyclingSampleQueuePair(
      const SampleQueueSharedPtr& pSampleQueue,
      const SampleQueueSharedPtr& pRecycledSampeQueue)
      : m_pSampleQueue(pSampleQueue),
        m_pRecycledSampleQueue(pRecycledSampeQueue) {

  }

  SampleQueueSharedPtr sampleQueue() {
    return m_pSampleQueue;
  }

  SampleQueueSharedPtr recycledSampleQueue() {
    return m_pRecycledSampleQueue;
  }

 private:
  SampleQueueSharedPtr m_pSampleQueue;
  SampleQueueSharedPtr m_pRecycledSampleQueue;
};

template<typename Sample, typename SampleQueue> RecyclingSampleQueuePair<
  Sample> recyclingSampleQueuePair(
    std::size_t maxCountSamples) {
  typedef Sample SampleType;
  typedef RecyclingSampleQueuePair<Sample> RecyclingSampleQueuePairType;
  typedef boost::shared_ptr<SampleQueue> SampleQueueSharedPtr;
  SampleQueueSharedPtr pSampleQueue(new SampleQueue(maxCountSamples));
  SampleQueueSharedPtr pRecycledSampeQueue(
      new SampleQueue(maxCountSamples));
  RecyclingSampleQueuePairType recyclingSampleQueuePair(
      pSampleQueue,
      pRecycledSampeQueue);
  return recyclingSampleQueuePair;
}

template<typename Sample> RecyclingSampleQueuePair<
  Sample> threadSafeRecyclingSampleQueuePair(std::size_t maxCountSamples) {
  typedef Sample SampleType;
  typedef ThreadSafeSampleQueueImpl<SampleType> SampleQueueType;
  return recyclingSampleQueuePair<SampleType, SampleQueueType>(maxCountSamples);
}

template<typename Sample> RecyclingSampleQueuePair<
  Sample> singleThreadedRecyclingSampleQueuePair(
    std::size_t maxCountSamples) {
  typedef Sample SampleType;
  typedef SampleQueueImpl<SampleType> SampleQueueType;
  return recyclingSampleQueuePair<SampleType, SampleQueueType>(maxCountSamples);
}

} // VideoCapture



#endif // VIDEO_CAPTURE_RECYCLING_SAMPLE_QUEUE_PAIR_H
