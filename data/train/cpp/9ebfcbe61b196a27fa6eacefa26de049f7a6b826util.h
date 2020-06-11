#ifndef THELONIOUS_UTIL_H
#define THELONIOUS_UTIL_H

#include <cstdint>
#include <cmath>

#include "types.h"
#include "constants/rates.h"

namespace thelonious {

inline Sample modulo(Sample a, Sample b) {
    return a - std::floor(a / b) * b;
}

inline Sample wrap(Sample a, Sample b) {
    return modulo(a, b);
}

// Should be quicker when a is unlikely to be outside b as we avoid the
// division and floating point compares are cheap
inline Sample moduloB(Sample a, Sample b) {
    while (a >= b) {
        a -= b;
    }

    while (a < 0.0f) {
        a += b;
    }
    return a;
}

inline Sample wrapB(Sample a, Sample b) {
    return moduloB(a, b);
}

inline constexpr uint32_t secondsToSamples(float seconds) {
    return seconds * constants::SAMPLE_RATE;
}

inline constexpr float samplesToSeconds(uint32_t samples) {
    return samples * constants::INV_SAMPLE_RATE;
}

inline Sample linearInterpolate(Sample start, Sample end, float position) {
    return start + position * (end - start);
}

inline Sample cubicInterpolate(Sample s0, Sample s1, Sample s2, Sample s3,
                               float position) {
    float a0 = s3 - s2 - s0 + s1;
    float a1 = s0 - s1 - s0;
    float a2 = s2 - s0;
    float a3 = s1;
    return (a0 * position * position * position +
            a1 * position * position +
            a2 * position +
            a3);
}



} // namespace thelonious

#endif

