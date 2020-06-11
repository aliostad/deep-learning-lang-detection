#pragma once
#include <config.h>
#include <core/Time.h>
#include <math.scalar/core.h>
#include <math.statistics/IAverage.h>
namespace nspace{
  class AverageRate : public IAverage{
  private:
    IAverage & _average;
    bool _initialized;
    Time _lastSampleTime;
    Real _lastSample;
  public:
    AverageRate(IAverage & average):_average(average),_initialized(false){
    }
    void addSample( Real sample ){
      if(!_initialized){
        _lastSampleTime = systemTime();
        _lastSample = sample;
        _initialized = true;
        return;
      }

      Time t_sys = systemTime();
      Time dt = t_sys - _lastSampleTime;
      Real delta = sample-_lastSample;
      Real currentRate = delta /dt ;

      _average.addSample(currentRate);

      _lastSample = sample;
      _lastSampleTime =t_sys;
    }

    Real calculate(){
      return _average.calculate();
    }
  };
}
