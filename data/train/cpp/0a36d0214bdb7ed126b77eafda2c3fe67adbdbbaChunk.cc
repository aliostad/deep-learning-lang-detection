/*
* Chunk.cpp
*
*  Created on: Sep 28, 2010
*      Author: daniele
*/

#include <cassert>
#include <cstring>

#include "Chunk.h"
#include "BufferDescriptor.h"

Chunk::Chunk( std::size_t offset )
	: _descriptor(offset, 0)
{
}

Chunk::Chunk( char const * data, BufferDescriptor descriptor )
	: _descriptor(descriptor)
{
	if (data)
		_data.assign(data, data + _descriptor.size());
}

Chunk::Chunk(char const * data, std::size_t size)
	: _descriptor(0, size)
{
	if (data)
		_data.assign(data, data + _descriptor.size());
}

Chunk::~Chunk()
{

}
