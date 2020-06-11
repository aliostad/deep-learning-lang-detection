#include "FfmpegPacketSample.h"

FfmpegPacketSample::FfmpegPacketSample()
{
	av_init_packet(&m_packet);
	
	m_packet.data=nullptr;
	m_packet.size=0;
}

FfmpegPacketSample::~FfmpegPacketSample()
{
	if(m_packet.data)
		av_free_packet(&m_packet);

}

unsigned char *FfmpegPacketSample::buffer()
{
	return m_packet.data;
}

size_t FfmpegPacketSample::size() const
{
	return m_packet.size;
}

void FfmpegPacketSample::allocate(size_t size)
{

}

void FfmpegPacketSample::freeBuffer()
{

}


size_t FfmpegPacketSample::actualSize() const
{
	return m_packet.size;
}