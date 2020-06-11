/* 
 * File:   sample.cpp
 * Author: C0320318
 * 
 * Created on November 18, 2014, 10:14 AM
 */

#include "Sample.h"

template <class a_T>
Sample<a_T>::Sample(unsigned int mnos) {
    max_samples = mnos;
    sample_index = 0;
    samples = new a_T[mnos];

    for(unsigned int i=0; i<mnos; i++){
        samples[i]=0;
    }

    sum = (a_T)(0);
    current = (a_T)(0);
    average = (a_T)(0);
    //calibrated = (a_T)(0);
}

template <class a_T>
a_T Sample<a_T>::GetAverage(){
    return average;
}

template <class a_T>
a_T Sample<a_T>::GetCurrent(){
    return current;
}

template <class a_T>
a_T Sample<a_T>::GetSum(){
    return sum;
}

template <class a_T>
a_T Sample<a_T>::Update(a_T sample_data){
  current = sample_data;
  sum += current;
  sum -= samples[sample_index];
  samples[sample_index] = current;
  average = sum/max_samples;
  sample_index++;
  if(sample_index == max_samples) sample_index = 0;
  return average;
}

template <class a_T>
Sample<a_T>::~Sample() {
    delete[] samples;
}

template class Sample<int>;
template class Sample<float>;
