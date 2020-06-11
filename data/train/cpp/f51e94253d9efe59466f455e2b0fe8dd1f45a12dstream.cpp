/*******************************************************************************
 * WayStudio Library
 * Developer:Xu Waycell
 *******************************************************************************/
#include <stream.hpp>
#include <streamimpl.hpp>

BEGIN_SOURCECODE
        
BEGIN_WS_NAMESPACE
        
Stream::StreamImplementation::StreamImplementation(StreamBuffer* P):buffer(P){}

Stream::StreamImplementation::~StreamImplementation(){}

Stream::Stream(StreamBuffer* BUF):implementation(0)
{
    implementation=new StreamImplementation(BUF);
}

Stream::~Stream(){}

StreamBuffer* Stream::buffer() const
{
    if(implementation)
        return implementation->buffer;
	return 0;
}

END_WS_NAMESPACE
        
END_SOURCECODE
