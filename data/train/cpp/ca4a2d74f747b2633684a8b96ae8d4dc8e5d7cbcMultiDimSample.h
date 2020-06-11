#ifndef MULTIDIMSAMPLE_H
#define MULTIDIMSAMPLE_H
#include <vector>
#include <iostream>

using namespace std;

class MultiDimSample
{
private:
	int d_X;
	vector <double > X;
public:
	MultiDimSample();
	MultiDimSample(int);   
	MultiDimSample(double, int); 
	MultiDimSample(double *, int); 
 	MultiDimSample(const MultiDimSample &); 
	int dimension() const;  
	MultiDimSample & operator = (const MultiDimSample &); 
	double & operator [] (int n); 	
	MultiDimSample operator + (MultiDimSample) ;
	friend ostream &operator << (ostream &, MultiDimSample);  
};
#endif
