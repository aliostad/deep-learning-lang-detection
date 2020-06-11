#include "dftUtils.hpp"
#define _USE_MATH_DEFINES
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
/*!
 * @brief 周波数領域での複素積算　空間領域での畳み込みに相当 
 * @param [] 
 */
int fr_multi(double *dest_r, double *dest_i, const double *src_r,const double *src_i, const double *filter_r, const double *filter_i,
	int sampleSize)
{
	for(int i=0 ; i < sampleSize ; i++)
	{
		dest_r[i] = src_r[i] * filter_r[i] + (src_i[i]*filter_i[i])*-1;
		dest_i[i] = src_r[i] * filter_i[i] + (src_i[i]*filter_r[i]);
	}	
	return SUCCESS;
}

/*!
 * @brief 空間領域での畳み込み
 * @param [] 
 */
int conv(double *dest_r, const double *src_r, const double *filter_r,
	int sampleSize)

{
	for(int i=0; i< sampleSize; i++)
	{
		dest_r[i] = 0;
		for(int j = 0; j < sampleSize ; j++)
		{
			int _j_i = (j - i) % sampleSize;
			dest_r[i] += src_r[i] * filter_r[_j_i];
		}
	}
	return SUCCESS;
}

/*!
 * @brief DFT
 * @param [] 
 */
int dft(double *dest_r, double *dest_i,
	const double *src_r, const double *src_i, 
	int sampleSize, bool inverse)
{
	double sum_re, sum_im, pi, arg, freqSample;
	int sample;
	int freq;

	if(dest_r == NULL || dest_i == NULL ||
		src_r == NULL || src_i == NULL || sampleSize <= 1){
			return FAILURE;
	}

	// initializing a destination array
	for( sample=0; sample < sampleSize; sample++)
	{
		dest_r[sample] = 0.0;
		dest_i[sample] = 0.0;
	}

	pi = (inverse == false)? M_PI: -M_PI;

	// main loop
	for( freq=0; freq<sampleSize; freq++)
	{
		sum_re = 0.0;
		sum_im = 0.0;
		arg = ((double)freq/(double)sampleSize) * (2*pi);
		for( sample=0; sample<sampleSize; sample++)
		{
			freqSample = sample * arg;

			sum_re += src_r[sample] * cos( freqSample )
				+ src_i[sample] * sin( freqSample );
			sum_im += src_i[sample] * cos( freqSample )
				- src_r[sample] * sin( freqSample );
		}
		if(inverse){
			dest_r[freq] = sum_re;
			dest_i[freq] = sum_im;
		}else{
			dest_r[freq] = sum_re/(double)sampleSize;
			dest_i[freq] = sum_im/(double)sampleSize;
		}
	}

	return SUCCESS;
}
