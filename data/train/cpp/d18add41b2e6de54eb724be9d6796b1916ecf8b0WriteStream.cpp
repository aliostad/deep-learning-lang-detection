#include "Stream.h"

Stream::Stream()
{
}

void Stream::Clear()
{
	memset(stream, 0, sizeof(stream));
	pos = 0;
}

char* Stream::GetStream()
{
	return stream;
}

int Stream::GetLength()
{
	return pos;
}

WriteStream::WriteStream() : Stream()
{
	stream = new char[10000];
}

WriteStream::~WriteStream()
{
	delete stream;
}

void WriteStream::WriteByte(unsigned char data)
{
	memcpy(stream + pos, &data, sizeof(unsigned char));
	pos += sizeof(unsigned char);
}

void WriteStream::WriteShort(short data)
{
	memcpy(stream + pos, &data, sizeof(short));
	pos += sizeof(short);
}

void WriteStream::WriteInt(int data)
{
	memcpy(stream + pos, &data, sizeof(int));
	pos += sizeof(int);
}

void WriteStream::WriteLong(long data)
{
	memcpy(stream + pos, &data, sizeof(long));
	pos += sizeof(long);
}

void WriteStream::WriteString(std::string data)
{
	WriteShort(data.length());
	memcpy(stream + pos, data.c_str(), data.length());
	pos += data.length();
}

void WriteStream::WriteObjPointer(void* data)
{
	memcpy(stream + pos, &data, sizeof(void*));
	pos += sizeof(void*);
}
