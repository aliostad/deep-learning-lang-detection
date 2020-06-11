// Copyright (c) 2008 Aurelio Lucchesi
// For information on usage and redistribution, and for a DISCLAIMER OF ALL
// WARRANTIES, see the file "LICENSE.txt" in this distribution.
//
// FileStream.cpp

#ifndef _FILE_STREAM_CPP_
#define _FILE_STREAM_CPP_

#include "FileStream.h"

////////////////////////////////////////////////////////////////////////////////
// CFileStream
////////////////////////////////////////////////////////////////////////////////

CFileStream::CFileStream()
: CFile()
{}

CFileStream::CFileStream( const CFileStream &roO )
: CFile()
{
	*this = roO;
}

CFileStream::~CFileStream()
{}

CFileStream & CFileStream::operator=( const CFileStream &roO )
{
	CFile::operator=( roO );
	return *this;
}

#endif // _FILE_STREAM_CPP_
