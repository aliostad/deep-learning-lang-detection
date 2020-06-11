#include "StdAfx.h"
#include "VBitStream.h"

VBitStream::VBitStream(int bitCount)
{
	this->setBitCount(bitCount);
}

VBitStream::VBitStream(){
	Type(BitStreamInfo::VERTICAL_STREAM_FORMAT);
}

BitStreamInfo * VBitStream::Clone()
{
	VBitStream * bit_stream = new VBitStream();	
	bit_stream->convert(getProcessedBitStream());
	bit_stream->Type(this->Type());
	BitStreamInfo::Clone(bit_stream);
	return bit_stream;
}

size_t VBitStream::SpaceUtilisation()
{
	size_t space = sizeof(this);
	space += Decompress().size()/ 8;
	return space;
}

VBitStream::~VBitStream(void)
{
}


dynamic_bitset<> VBitStream::Decompress(){
	return this->getProcessedBitStream();
}

void VBitStream::CompressWords(boost::dynamic_bitset<>& bitMap){
	this->convert(bitMap);
}


BitStreamInfo* VBitStream::operator ~(){
	BitStreamInfo * v_bit_stream = new VBitStream();
	dynamic_bitset<> temp_stream = this->getProcessedBitStream();
	temp_stream.flip();
	v_bit_stream->convert(temp_stream);
	return v_bit_stream;
}

BitStreamInfo* VBitStream::operator &(BitStreamInfo & _structure){
	VBitStream * v_bit_stream = new VBitStream();
	dynamic_bitset<> left_op = this->getProcessedBitStream();
	dynamic_bitset<> right_op = _structure.getProcessedBitStream();
	v_bit_stream->convert(left_op & right_op);
	return v_bit_stream;
}

BitStreamInfo* VBitStream::operator |(BitStreamInfo & _structure){
	VBitStream * v_bit_stream = new VBitStream();
	dynamic_bitset<> left_op = this->getProcessedBitStream();
	dynamic_bitset<> right_op = _structure.getProcessedBitStream();
	v_bit_stream->convert(left_op | right_op);
	return v_bit_stream;
}

unsigned long long VBitStream::Count(){
	return (unsigned long long)this->count();
}
