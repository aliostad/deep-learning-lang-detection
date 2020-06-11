// implementation of the sample analyzer template.


template< typename sample_t>
class analyze_mutator
{
public:

	typedef sample_t sample_type;
	typedef typename sampletraits<sample_type>::channel_type channel_type;
	struct typed_information
	{
		typed_information()
			:
				sum( sampletraits<sample_type>::expand_to_channels( 0.0)),
				sum_abs( sampletraits<sample_type>::expand_to_channels( 0.0)),
				max( sampletraits<sample_type>::get_min()),
				min( sampletraits<sample_type>::get_max()),
				count( 0)
		{
			// nop
		}

		// convert to a typeless analysis result;
		operator sound_analysis() const
		{
			sound_analysis result;
			result.avg = normalize_sample( channel_type(average_of_channels( sum)/count));
			result.norm= normalize_sample( channel_type(average_of_channels( sum_abs)/count));
			result.max = normalize_sample( max_of_channels( max));
			result.min = normalize_sample( min_of_channels( min));
			return result;
		}

		void reset()
		{
			*this = typed_information();
		}


		typename sampletraits<sample_type>::template foreach_channel_type<double>::type sum;
		typename sampletraits<sample_type>::template foreach_channel_type<double>::type sum_abs;
		sample_type max;
		sample_type min;
		sampleno count;
		inline double get_average() { return sum/count;}
	};

	typedef typed_information result_information_type;

	void MutateHeader( const stream_header &)
	{
		// nop
	}

	void Mutate( const sample_t *sample)
	{
		state.max = max_sample( state.max, *sample);
		state.min = min_sample( state.min, *sample);
		state.sum += *sample;
		state.sum_abs += abs( typename sampletraits<sample_t>::template foreach_channel_type<double>::type( *sample));
		++state.count;
	}

	void Reset()
	{
		state.reset();
	}

	typed_information GetResult()
	{
		return  state;
	}

private:


	// helper functions to calculate the maximum value of the channels of a
	// multi-channels sample
	//
	template <typename sampletype>
		inline static double average_of_channels( const sampletype &sample)
	{
		return sample;
	}

	template <typename sampletype>
		inline static double average_of_channels( const StereoSample< sampletype> &sample)
	{
		typedef typename sampletraits<sampletype>::accumulator_type accu_type;
		return (double( average_of_channels( sample.m_left)) +
				double( average_of_channels( sample.m_right)))/2;
	}

	template <typename sampletype>
	inline static sampletype max_of_channels( const sampletype &sample)
	{
		return sample;
	}

	template <typename sampletype>
		inline static sampletype max_of_channels( const StereoSample< sampletype> &sample)
	{
		return max_sample( sample.m_left, sample.m_right);
	}

	template <typename sampletype>
	inline static sampletype min_of_channels( const sampletype &sample)
	{
		return sample;
	}

	template <typename sampletype>
		inline static sampletype min_of_channels( const StereoSample< sampletype> &sample)
	{
		return min_sample( sample.m_left, sample.m_right);
	}

	typed_information state;
};


template< typename sample_type>
struct typed_analyzer : public uniform_block_mutator< analyze_mutator< sample_type>, sample_analyzer >
{
	typedef uniform_block_mutator< analyze_mutator< sample_type>, sample_analyzer > parent_type;
	virtual sound_analysis GetResult()
	{
		return parent_type::m_sample_mutator.GetResult();
	}

	virtual void Reset()
	{
		parent_type::m_sample_mutator.Reset();
	}
};
