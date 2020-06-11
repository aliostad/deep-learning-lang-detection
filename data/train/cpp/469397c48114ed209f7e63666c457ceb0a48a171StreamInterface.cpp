/////////////////////////////////////////////////////////////
/** @file StreamInterface.cpp
 *  @ingroup Utils
 *
 *  @author Luk2010
 *  @version 0.1A
 *
 *  @date 04/01/2013 - 23/03/2014
 *
 *  Implements the Streams class.
 *
**/
/////////////////////////////////////////////////////////////
#include "StreamInterface.h"

namespace APro
{
    CursorStream::CursorStream()
    {

    }

    CursorStream::~CursorStream()
    {

    }

    bool CursorStream::operator bool() const
    {
        return !isEOS();
    }

    size_t CursorStream::size()
    {
        size_t _p, _ret;

        _p = tell();
        seek(0, CP_END);
        _ret = tell();
        seek(_p, CP_BEGIN);

        return ret;
    }

    InputStream::InputStream()
     : CursorStream()
    {

    }

    InputStream::~CursorStream()
    {

    }

    InputStream& InputStream::operator >> (String& str)
    {
        readWord(str);
        return *this;
    }

    InputStream& InputStream::operator >> (Real& r)
    {
        readReal(r);
        return *this;
    }

    InputStream& InputStream::operator >> (int& i)
    {
        readInt(i);
        return *this;
    }

    OutputStream::OutputStream()
    {

    }

    OutputStream::~OutputStream()
    {

    }

    OutputStream& OutputStream::operator << (const String& str)
    {
        write(str);
        return *this;
    }

    OutputStream& OutputStream::operator << (const Real& r)
    {
        write(r);
        return *this;
    }

    OutputStream& OutputStream::operator << (const int& i)
    {
        write(i);
        return *this;
    }
}
