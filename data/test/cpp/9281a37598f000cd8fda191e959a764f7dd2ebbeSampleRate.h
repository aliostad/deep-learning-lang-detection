#ifndef __CCDSP_SAMPLERATE__
#define __CCDSP_SAMPLERATE__

#include "ccdsp/Base.h"

namespace ccdsp {

struct SampleRate {
  SampleRate() {}

  SampleRate(double r) : rate_(r) {}
  SampleRate(float r) : rate_(r) {}

  SampleRate(int64 r) : rate_(r) {}
  SampleRate(int32 r) : rate_(r) {}
  SampleRate(int16 r) : rate_(r) {}
  SampleRate(int8 r) : rate_(r) {}

  SampleRate(uint64 r) : rate_(r) {}
  SampleRate(uint32 r) : rate_(r) {}
  SampleRate(uint16 r) : rate_(r) {}
  SampleRate(uint8 r) : rate_(r) {}

  const double operator*() const { return rate_; }

 private:
  double rate_;
};

}  // namespace ccdsp

#endif  // __CCDSP_SAMPLERATE__
