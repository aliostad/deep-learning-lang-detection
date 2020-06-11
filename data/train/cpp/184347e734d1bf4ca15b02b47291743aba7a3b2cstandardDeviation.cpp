//Homework 1, Problem 1
//Calculate Standard Deviation
//Liam Abbott, leabbott

#include <iostream>
#include <cstdlib>
#include <cmath>
using namespace std;

int main(int argc, char * argv[]) {

	double sample_mean = atof(argv[1]);
	double sample_var;

	for (int i=2; i<argc; i++)
	{
		sample_var = sample_var + ((double(i)-1)/double(i)) * (atof(argv[i]) - sample_mean) * (atof(argv[i]) - sample_mean);
		sample_mean = sample_mean + ((atof(argv[i]) - sample_mean)/double(i));
	}

	sample_var = sample_var/double(argc-2);
	double sample_sd = sqrt(sample_var);

	cout.precision(8);
	cout << sample_sd << endl;

	return 0;
}
