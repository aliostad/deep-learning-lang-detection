#include "packetlibop.h"

void sig_ext(word *data, int numElements, double *maximum, double *time)
{
	const int maxSample=40, windowSize=9;
	int i(1119); // Edit this line to change the pixel number
	int pixel = i * maxSample; 
	
	*maximum =0.;
	*time=0.;
	int position = 0; 
	double sum = 0.;
		
	// Test
	cout << endl << "Pixel no. " << i << " :";
	for (word k=i; k <= i; k++)
	{
		for (word sample = 0; sample < maxSample; sample ++)
		{
			cout << data[k*40 + sample] << " ";
		}
		cout << endl;
	}		
	
	// Maximum sum (sliding window search)
	for (int sample = 0; sample < windowSize; ++sample)
	{
		sum += data[pixel + sample];
	}
	*maximum = sum;
	for (int sample = 1; sample <= maxSample - windowSize; ++sample)
	{
		sum += data[pixel + windowSize + sample - 1] - data[pixel + sample - 1];
		if (sum > *maximum)
		{
			*maximum = sum;
			position = sample;
		}
	}
	// Time
	sum = 0.;
	for (int sample=0; sample < windowSize; ++sample)
	{
		sum += data[pixel + position + sample] * (position + sample);
	}
	*time = sum / *maximum;
}