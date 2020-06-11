
#include "samples.hpp"

SampleBuffer::SampleBuffer(short _number_of_samples) {
  number_of_samples = _number_of_samples;
  current_sample_index = 0;
  if (number_of_samples > 0) {
    samples = (Sample *)calloc(number_of_samples, sizeof(Sample));
    valid = samples ? true : false;
  } else {
    samples = NULL;
    valid = false;
  }
}

SampleBuffer::~SampleBuffer() {
  valid = false;
  free(samples);
}

void SampleBuffer::fill_with(Sample sample) {
  for (int i = 0; i < number_of_samples; ++i) {
    replaced_by(sample);
  }
}

Sample SampleBuffer::replaced_by(Sample new_sample) {
  if (!valid) {
    return 0;
  }
  Sample old_sample = samples[current_sample_index];
  samples[current_sample_index] = new_sample;
  ++current_sample_index;
  current_sample_index %= number_of_samples;
  return old_sample;
}

boolean SampleBuffer::is_valid() {
  return valid;
}

short SampleBuffer::size() {
  return number_of_samples;
}

