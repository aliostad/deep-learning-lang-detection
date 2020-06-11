#pragma once

#include "value_time.h"

namespace xTunnel
{
    class Speedometer
    {
    public:
        Speedometer()
        {
            sample_index_ = -1;
        }

        void SetValue(int64_t value)
        {
            sample_index_ = next_index(sample_index_);
            samples_[sample_index_] = ValueSample(value, GetTickCount());
        }

        double speed() const
        {
            int last_index = sample_index_;
            if (last_index < 0)
            {
                return 0;
            }

            const ValueSample& last = samples_[last_index];
            
            ValueSample first;
            int first_index = next_index(last_index);
            for (int i = 1; i < SampleCount; ++i, first_index = next_index(first_index))
            {
                ValueSample sample = samples_[first_index];
                if (last.time > sample.time && sample.time != 0)
                {
                    first = sample;
                    break;
                }
            }

            if (first.time == 0)
            {
                return 0;
            }

            double duration_in_sec = (last.time - first.time) / 1000.0;
            if (duration_in_sec >= 0.0)
            {
                return (last.value - first.value) / duration_in_sec;
            }
            else
            {
                return 0.0;
            }
        }


    private:
        static inline int next_index(int index)
        {
            return (index + 1) % SampleCount;
        }

        typedef ValueTime<__int64> ValueSample;
        
        volatile int sample_index_;
        static const int SampleCount = 10;
        ValueSample samples_[SampleCount];
    };
}