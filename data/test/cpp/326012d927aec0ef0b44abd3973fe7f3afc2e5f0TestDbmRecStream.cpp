/* $Id: TestDbmRecStream.cpp,v 1.1 2002/09/15 07:46:30 pgr Exp $ */

#include "TestDbmRecStream.h"
#include "PalmDbmStream.h"

char const TestDbmRecStream::fileName[] = "HelloRecDB";

/*----------------------------------------------------TestDbmRecStream::title-+
|                                                                             |
+----------------------------------------------------------------------------*/
char const * TestDbmRecStream::title() {
   return "TestDbmRecStream";
}

/*-----------------------------------------TestDbmRecStream::TestDbmRecStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
TestDbmRecStream::TestDbmRecStream() {
   pStream = 0;
}

/*----------------------------------------TestDbmRecStream::~TestDbmRecStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
TestDbmRecStream::~TestDbmRecStream() {
   delete pStream;
}

/*---------------------------------------------TestDbmRecStream::newOutStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
ostream * TestDbmRecStream::newOutStream() {
   if (pStream) delete pStream;
   pStream = new PalmDbmRecStream(fileName, dmModeWrite, 1, 0, 'Jaxo');
   return pStream;
}

/*----------------------------------------------TestDbmRecStream::newInStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
istream * TestDbmRecStream::newInStream() {
   if (pStream) delete pStream;
   pStream = new PalmDbmRecStream(fileName, dmModeReadOnly, 1, 0, 'Jaxo');
   return pStream;
}

/*-------------------------------------------TestDbmRecStream::newInOutStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
iostream * TestDbmRecStream::newInOutStream() {
   if (pStream) delete pStream;
   pStream = new PalmDbmRecStream(fileName, dmModeReadWrite, 1, 0, 'Jaxo');
   return pStream;
}

/*------------------------------------------------TestDbmRecStream::hasFailed-+
|                                                                             |
+----------------------------------------------------------------------------*/
bool TestDbmRecStream::hasFailed() {
   if (pStream && !*pStream) {
      ErrAlert(pStream->getLastError());
      return true;
   }else {
      return false;
   }
}

/*===========================================================================*/
