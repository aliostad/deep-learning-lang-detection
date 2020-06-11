
//#define DEBUG_OUT std::cerr
#define DEBUG_OUT *aNullStream


#include <iostream>
#include <stdio.h>

#include "ANullStream.h"


ANullStream *aNullStream=new ANullStream();


////////////////////////////////////////////////////////////////////////////////
//  ANullStream Class
////////////////////////////////////////////////////////////////////////////////

ANullStream::ANullStream()
{
}


ANullStream& ANullStream::operator<<(float n)
{
  return *this;
}


ANullStream& ANullStream::operator<<(double n)
{
  return *this;
}


ANullStream& ANullStream::operator<<(unsigned long s)
{
  return *this;
}


ANullStream& ANullStream::operator<<(long s)
{
  return *this;
}


ANullStream& ANullStream::operator<<(unsigned short s)
{
  return *this;
}


ANullStream& ANullStream::operator<<(short s)
{
  return *this;
}


ANullStream& ANullStream::operator<<(unsigned int s)
{
  return *this;
}


ANullStream& ANullStream::operator<<(int s)
{
  return *this;
}


// NOTE: This is the main output routine for strings.
ANullStream& ANullStream::operator<<(const char *foo)
{
  return *this;
}


// NOTE: This is the main output routine for characters.
ANullStream& ANullStream::operator<<(char c)
{
  return *this;
}


ANullStream& ANullStream::hex()
{
  return *this;
}


ANullStream& ANullStream::dec()
{
  return *this;
}

