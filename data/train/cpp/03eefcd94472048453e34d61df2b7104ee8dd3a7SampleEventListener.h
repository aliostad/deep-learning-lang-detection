
/**
 SampleEventListener interface that must be implemented by all
classes that want to subscribe to sample events.

*/

#ifndef _SAMPLEEVENTLISTENER_H
#define _SAMPLEEVENTLISTENER_H

#include <stdint.h>

typedef uint16_t sample_t;

const int MAX_SAMPLE_VALUE = 1023;
const int MIN_SAMPLE_VALUE = 0;
const int POSSIBLE_SAMPLE_VALUES = MAX_SAMPLE_VALUE - MIN_SAMPLE_VALUE + 1;
const int MID_SAMPLE_VALUE = (MAX_SAMPLE_VALUE - MIN_SAMPLE_VALUE) / 2;

class SampleEventListener {
  public:
    virtual ~SampleEventListener() {};
    virtual void sample(sample_t value) = 0;
};

#endif
