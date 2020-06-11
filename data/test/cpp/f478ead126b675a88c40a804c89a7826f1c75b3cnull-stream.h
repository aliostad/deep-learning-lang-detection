#ifndef NULL_STREAM_H
#define NULL_STREAM_H

#include <sstream>
#include <iostream>

using namespace std;

class null_stream
{

 public:
 null_stream()
 {
 }

 template <typename T> friend null_stream& operator << (null_stream& out_stream, const T& t)
 {
     return out_stream;
 }

 template <typename T> friend null_stream& operator << (null_stream& out_stream, T& t)
 {
     return out_stream;
 }

 friend null_stream& operator << (null_stream& out_stream, std::ostream& (*fn)(std::ostream&) )
 {
     return out_stream;
 }

};

static null_stream my_null_stream;

#endif
