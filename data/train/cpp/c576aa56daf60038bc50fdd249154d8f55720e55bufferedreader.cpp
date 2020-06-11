/*
 * bufferedreader.cpp
 *
 *  Created on: 6 janv. 2010
 *      Author: francois
 */

#include <Xemeiah/io/bufferedreader.h>
#include <Xemeiah/trace.h>
#include <Xemeiah/kern/exception.h>

#include <Xemeiah/auto-inline.hpp>

#define Log_BufferedReader Debug

namespace Xem
{
  BufferedReader::BufferedReader ()
  {
    encoding = Encoding_UTF8;
    buffer = NULL;
    bufferSz = 0;
    bufferIdx = 0;
    totalParsed = 0;
    totalLinesParsed = 0;
  }

  BufferedReader::~BufferedReader ()
  {

  }

  void BufferedReader::setEncoding ( Encoding _encoding )
  {
    encoding = _encoding;
  }

  Encoding BufferedReader::getEncoding ()
  {
    return encoding;
  }

  String BufferedReader::dumpCurrentContext ()
  {
    String context;
    stringPrintf ( context, "at file='%s', line %llu, char %llu : ",
        getCurrentURI().c_str(),
        totalLinesParsed, totalParsed );

    if ( buffer )
      {
        static const __ui64 MaxBufferDumpSize = 256;
        char _dumpBuff[MaxBufferDumpSize];
        __ui64 _dumpBuffStart, _dumpBuffSize = 0;
        _dumpBuffStart = bufferIdx;
        while ( _dumpBuffStart && buffer[_dumpBuffStart] != '\n' &&
                ( bufferIdx - _dumpBuffStart < MaxBufferDumpSize / 2 ) )
          _dumpBuffStart--;
        if ( _dumpBuffStart ) _dumpBuffStart++;
        while ( _dumpBuffSize < bufferSz && buffer[_dumpBuffStart + _dumpBuffSize] != '\n' )
          _dumpBuffSize++;
        if ( _dumpBuffSize > MaxBufferDumpSize )
          _dumpBuffSize = MaxBufferDumpSize;

        memcpy ( _dumpBuff, &(buffer[_dumpBuffStart]), _dumpBuffSize );
        _dumpBuff[_dumpBuffSize-1] = '\0';
        context += _dumpBuff;
        context += "\n";
      }
    else
      {
        context += "(Unknown context)";
      }
    return context;
  }
};
