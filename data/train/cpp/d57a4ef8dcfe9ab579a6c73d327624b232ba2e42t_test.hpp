/*
	Student T Test Implementation.
*/

#ifndef T_TEST_HPP
#define T_TEST_HPP

#include "iostream"
#include <vector>

#include <boost/math/distributions/students_t.hpp>

using namespace std;
using namespace boost::math;

template<typename T>
T mean(std::vector<T> data)
{
	if(data.empty())
		return 0;

	T sum;
	for (typename std::vector<T>::const_iterator it = data.begin(); it != data.end(); ++it)
	{
		sum += *it;
	}

	return (sum/(int)data.size());
}

template<typename T>
T sample_variance(std::vector<T> data, T mean)
{
	T _sample_variance, _sample_square_dist;
	for (typename std::vector<T>::const_iterator it = data.begin(); it != data.end(); ++it)
	{
		_sample_square_dist += pow((*it - mean), 2);
	}

	_sample_variance = _sample_square_dist / ((int)data.size() - 1);

	return _sample_variance;
}


template<typename T>
std::pair<T, T> t_statistics(std::vector<T> sample1, std::vector<T> sample2)
{
	T _mean_diff, _t_statistic, _degrees_of_freedom, _sample_1_mean, _sample_2_mean, _sample_1_variance, 
		_sample_2_variance, _sample_1_avg_variance, _sample_2_avg_variance, _sample_avg_variance;
	int _sample_1_size, _sample_2_size;

	_sample_1_size = (int)sample1.size(); 
	_sample_2_size = (int)sample2.size();

	_sample_1_mean = mean<T>(sample1);
	_sample_2_mean = mean<T>(sample2);

	_sample_1_variance = sample_variance<T>(sample1, _sample_1_mean);
	_sample_2_variance = sample_variance<T>(sample2, _sample_2_mean);

	_mean_diff = abs(_sample_1_mean - _sample_2_mean);

	_sample_1_avg_variance = _sample_1_variance/_sample_1_size;
	_sample_2_avg_variance = _sample_2_variance/_sample_2_size;
	_sample_avg_variance   = (_sample_1_avg_variance + _sample_2_avg_variance);
	
	_t_statistic = _mean_diff/( sqrt(_sample_avg_variance) );
	_degrees_of_freedom = pow(_sample_avg_variance, 2) / ( (pow(_sample_1_avg_variance, 2)/(_sample_1_size - 1)) + (pow(_sample_2_avg_variance, 2)/(_sample_2_size - 1)) );

	return std::pair<T, T>(_t_statistic, _degrees_of_freedom);
}


template<typename T>
double similarity_probability(std::vector<T> sample1, std::vector<T> sample2)
{
	if(sample1.empty() || sample2.empty())
	{
		std::cout << "Empty sample(s) sent for calculating similarity." << endl;
		return (T)0;
	}

	std::pair<T, T> _t_statistics = t_statistics<T>(sample1, sample2);

	students_t dist(_t_statistics.second);

 	double _similarity_probability = cdf(complement(dist, fabs(_t_statistics.first)));

 	return (2*_similarity_probability);
}

#endif