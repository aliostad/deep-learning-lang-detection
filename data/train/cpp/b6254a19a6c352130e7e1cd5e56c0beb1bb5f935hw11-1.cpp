/*
Copyright (c) 2015 @myuuuuun
https://github.com/myuuuuun
*/
#include <iostream>
#include "MT.h"
#include <cmath>
using namespace std;


// MT19937 から一様分布を発生
double uniform(void){
    return genrand_real3();
}


int main(){
  // メルセンヌ・ツイスタ初期化
  init_genrand(214);

  for(int n=1; n<=20; n++){
    int sample_size = pow(2, n);
    double sample_sum = 0, squared_sample_sum = 0;
    double s, sample_ave, sample_var;

    for(int i=0; i<sample_size; i++){
      s = uniform();
      sample_sum += pow(s, 2);
      squared_sample_sum += pow(s, 4);
    }

    sample_ave = sample_sum / sample_size;
    sample_var = (squared_sample_sum / sample_size) - pow(sample_ave, 2);
    cout << n << ", " << sample_ave << ", " << sample_var << endl;
  }

  return 0;
}