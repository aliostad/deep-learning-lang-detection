#ifndef __CCDSP_SAMPLETIME__
#define __CCDSP_SAMPLETIME__

#include "ccdsp/Base.h"
#include "ccdsp/RealTime.h"
#include "ccdsp/SampleRate.h"

namespace ccdsp {

struct SampleTime {
  SampleTime() {}

  // A SampleTime can be constructed from any integer type.
  SampleTime(int64 t) : time_(t) {}
  SampleTime(int32 t) : time_(t) {}
  SampleTime(int16 t) : time_(t) {}
  SampleTime(int8 t) : time_(t) {}

  SampleTime(uint64 t) : time_(t) {}
  SampleTime(uint32 t) : time_(t) {}
  SampleTime(uint16 t) : time_(t) {}
  SampleTime(uint8 t) : time_(t) {}

  // And you can construct a SampleTime from a RealTime if you have a SampleRate.
  SampleTime(RealTime t, SampleRate r)
      : time_(static_cast<int64>((*t) * (*r))) {
  }

  const int64 operator*() const { return time_; }

  SampleTime& operator++() { ++time_; return *this; }
  SampleTime& operator--() { --time_; return *this; }

  SampleTime operator++(int) { return time_++; }
  SampleTime operator--(int) { return time_--; }

  SampleTime& operator-=(SampleTime t) { time_ -= *t; return *this; }
  SampleTime& operator+=(SampleTime t) { time_ += *t; return *this; }

  template <typename T> SampleTime& operator*=(T t) { time_ *= t; return *this; }
  template <typename T> SampleTime& operator/=(T t) { time_ /= t; return *this; }

 private:
  // Disallow floating point constructors.
  SampleTime(RealTime time);
  SampleTime(double time);
  SampleTime(float time);

  int64 time_;
};

inline const SampleTime operator+(SampleTime x, SampleTime y) {
  return (*x) + (*y);
}

inline const SampleTime operator-(SampleTime x, SampleTime y) {
  return (*x) - (*y);
}

template <typename T>
inline const SampleTime operator*(T x, SampleTime y) {
  return static_cast<int64>(x * (*y));
}

template <typename T>
inline const SampleTime operator*(SampleTime x, T y) {
  return static_cast<int64>((*x) * y);
}

const SampleTime operator*(SampleTime x, SampleTime y);
// Disallow this case - but by causing a link error.  TODO: a better way?

// Dividing a SampleTime by a SampleTime gives you a double.
inline const double operator/(SampleTime x, SampleTime y) {
  return static_cast<double>(*x) / (*y);
}

// Dividing a SampleTime by a number gives you a SampleTime.
template <typename T>
const SampleTime operator/(SampleTime x, T y) {
  return static_cast<int64>(static_cast<double>(*x) / y);
}

// Implementation of constructor defined in RealTime.h
inline RealTime::RealTime(const SampleTime& t, const SampleRate& r)
    : time_((*t) * (*r)) {
}

}  // namespace ccdsp

#endif  // __CCDSP_SAMPLETIME__
