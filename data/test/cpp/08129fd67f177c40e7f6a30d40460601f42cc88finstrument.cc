#include <assert.h>
#include <cmath>
#include <limits>

#include "instrument.h"

template <typename SampleType>
void ToneGeneratorInstrument<SampleType>::Generate(
    float frequency,  // Hz.
    float amplitude,  // [0-1].
    float length,     // Seconds.
    int sample_rate,  // Samples / second.
    int sample_offset,
    int sample_count,
    SampleType* samples) {
  assert(frequency >= 0);
  assert(amplitude >= 0 && amplitude <= 1);
  assert(sample_rate > 0);
  assert(sample_count >= 0);
  assert(samples);

  for (int sample = 0; sample < sample_count; ++sample) {
    int i = sample + sample_offset;
    if (i < 0 || i >= static_cast<int>(length * sample_rate)) {
      samples[sample] = 0;
      continue;
    }

    static const SampleType kMax = std::numeric_limits<SampleType>::max();
    static const SampleType kMin = std::numeric_limits<SampleType>::min();
    static const SampleType kMid = static_cast<SampleType>((kMax + kMin) / 2.0);
    samples[sample] = static_cast<SampleType>(
        kMid + amplitude * kMax / 2.0 *
        std::sin(2.0 * M_PI * float(i) / float(sample_rate) * frequency));
  }
}

// Explicity template instantiations of supported types.
template class ToneGeneratorInstrument<int>;
