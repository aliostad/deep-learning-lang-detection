#ifndef STREAM_CHANNEL_HPP
#define STREAM_CHANNEL_HPP

#include <vector>

namespace library
{
	class Stream;
	
	class ManagedStream
	{
	public:
		Stream* stream;
		float   volume;
	};
	
	class StreamChannel
	{
	public:
		StreamChannel() {}
		StreamChannel(float delta, float maxv);
		
		void play(Stream& newStream);
		void stop();
		void fullStop();
		void integrate();
		
	private:
		ManagedStream* streamExists(Stream& stream);
		void removeStream(Stream& stream);
		
		ManagedStream current;
		std::vector<ManagedStream> older;
		
		float delta;
		float maxVolume;
	};
}

#endif
