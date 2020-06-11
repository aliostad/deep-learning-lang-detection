#ifndef ALIB_ANULLSTREAM_H
#define ALIB_ANULLSTREAM_H


#include <iostream>


class ANullStream {
public:
  ANullStream();
  ANullStream& operator<<(unsigned long s);
  ANullStream& operator<<(long s);
  ANullStream& operator<<(unsigned short s);
  ANullStream& operator<<(short s);
  ANullStream& operator<<(unsigned int s);
  ANullStream& operator<<(int s);
  ANullStream& operator<<(char s);
  ANullStream& operator<<(float s);
  ANullStream& operator<<(double s);
  //
  ANullStream& operator<<(const char *s);
  //
  ANullStream& hex();
  ANullStream& dec();
protected:
};


extern ANullStream *aNullStream;


#endif // ALIB_ANULLSTREAM_H

