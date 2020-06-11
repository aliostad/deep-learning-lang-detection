
#ifndef samples_hpp
#define samples_hpp

#include "Arduino.h"
#include "units.hpp"

class SampleBuffer {
  public:
    // todo: can allocate less space if we know the bit size
    SampleBuffer(short number_of_normalized_samples);
    ~SampleBuffer();
    
    Sample replaced_by(Sample new_sample);
    
    void fill_with(Sample sample);

    boolean is_valid();
    
    short size();
    
  private:
    short number_of_samples;
    short current_sample_index;
    Sample *samples;
  protected:
    boolean valid;
  
};

class AveragingSampleBuffer : SampleBuffer {
  public:
    AveragingSampleBuffer(short number_of_normalized_samples);
    
    Sample replaced_by(Sample new_sample);
    
    long sum();
    Sample average();
    
    Sample normalize(Sample sample);
    
  protected:
    long sum_of_all_samples;
  
};

double half_life_sample_to_multiplier(double half_life);

class ExponentialAverage {
  public: 
    ExponentialAverage(double multiplier, double start = 0);
    
    void add_sample(Sample sample);
    
    const Sample average();
    
    const Sample normalize(Sample sample);
    
  private:
    double multiplier;
    double current_average;
};

#endif