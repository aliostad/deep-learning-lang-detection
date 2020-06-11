#ifndef _EXAMPLE_SET_H
#define _EXAMPLE_SET_H
#include "sample.h"
#include <vector>
/* 
	A wrapper class of a set of examples
*/



class SampleSet
{
public:

	static SampleSet& get_instance()
	{
		static SampleSet	instance;
		return instance;
	}


	void push_back( Sample*  );
	bool empty(){ return set_.empty(); }
	void clear();

	Sample& operator[](size_t idx)
	{
		if (idx >= set_.size())
		{
			Logger << " out of sample range\n ";
			return *set_[0];
		}
		return *set_[idx];
	}

	Vertex&	operator()(IndexType sample_idx, IndexType vertex_idx)
	{
		return  (*set_[sample_idx])[vertex_idx] ;
	}

	size_t size(){ return set_.size(); }

private:
	SampleSet(){}
	~SampleSet(){}

	SampleSet(const SampleSet& );
	void operator=(const SampleSet&);

private:
	std::vector<Sample*>	set_;

};

#endif