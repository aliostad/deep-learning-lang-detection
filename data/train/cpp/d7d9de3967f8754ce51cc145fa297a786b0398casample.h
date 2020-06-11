/*
  Datatype representing a sample.

  All samples in 10goto20 are stereo; there are simply no mono
  sources. A stereo sample where the left and right channels are the
  same is the recommended replacement for a mono sample.

  Amplitudes normally range from -1 to 1, however, intermediate values
  may be arbitrarily (finitely) large; compare "high dynamic range"
  lighting values in computer graphics.
*/

#ifndef __SAMPLE_H
#define __SAMPLE_H

struct Sample {
  double left;
  double right;
  double *samples() { return &left; }
  explicit Sample(double mono) : left(mono), right(mono) {}
  Sample(double l, double r) : left(l), right(r) {}
  // TODO PERF: Move constructors etc., unless the defaults
  // are created for us?
};

inline Sample operator +(const Sample &a, const Sample &b) {
  return Sample(a.left + b.left, a.right + b.right);
}

inline Sample operator -(const Sample &a, const Sample &b) {
  return Sample(a.left - b.left, a.right - b.right);
}

inline Sample operator /(const Sample &a, double b) {
  return Sample(a.left / b, a.right / b);
}

inline Sample operator *(const Sample &a, double b) {
  return Sample(a.left * b, a.right * b);
}

inline Sample operator -(const Sample &a) {
  return Sample(-a.left, -a.right);
}

inline Sample operator +(const Sample &a) {
  return a;
}

inline Sample &operator +=(Sample &a, const Sample &b) {
  a.left += b.left;
  a.right += b.right;
  return a;
}

inline Sample &operator -=(Sample &a, const Sample &b) {
  a.left -= b.left;
  a.right -= b.right;
  return a;
}

inline Sample &operator /=(Sample &a, double b) {
  a.left /= b;
  a.right /= b;
  return a;
}

inline Sample &operator *=(Sample &a, double b) {
  a.left *= b;
  a.right *= b;
  return a;
}

// Not overloading comparisons -- it's not obvious what
// should be less in e.g. (1.0, -1.0) vs (-1.0, 1.0)?

#endif
