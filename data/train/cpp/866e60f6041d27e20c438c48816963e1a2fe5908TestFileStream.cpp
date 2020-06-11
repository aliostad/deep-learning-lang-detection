/* $Id: TestFileStream.cpp,v 1.1 2002/09/15 07:46:30 pgr Exp $ */

#include "TestFileStream.h"
#include "PalmFileStream.h"

char const TestFileStream::fileName[] = "HelloFile";

/*----------------------------------------------=-------TestFileStream::title-+
|                                                                             |
+----------------------------------------------------------------------------*/
char const * TestFileStream::title() {
   return "TestFileStream";
}

/*---------------------------------------------TestFileStream::TestFileStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
TestFileStream::TestFileStream() {
   pStream = 0;
}

/*--------------------------------------------TestFileStream::~TestFileStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
TestFileStream::~TestFileStream() {
   delete pStream;
}

/*-----------------------------------------------TestFileStream::newOutStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
ostream * TestFileStream::newOutStream() {
   if (pStream) delete pStream;
   pStream = new PalmFileStream(
      fileName,
      fileModeReadWrite | fileModeAnyTypeCreator
   );
   return pStream;
}

/*------------------------------------------------TestFileStream::newInStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
istream * TestFileStream::newInStream() {
   if (pStream) delete pStream;
   pStream = new PalmFileStream(
      fileName,
      fileModeReadOnly | fileModeAnyTypeCreator
   );
   return pStream;
}

/*---------------------------------------------TestFileStream::newInOutStream-+
|                                                                             |
+----------------------------------------------------------------------------*/
iostream * TestFileStream::newInOutStream() {
   if (pStream) delete pStream;
   pStream = new PalmFileStream(fileName);
   return pStream;
}

/*--------------------------------------------------TestFileStream::hasFailed-+
|                                                                             |
+----------------------------------------------------------------------------*/
bool TestFileStream::hasFailed() {
   if (pStream && !*pStream) {
      ErrAlert(pStream->getLastError());
      return true;
   }else {
      return false;
   }
}

/*===========================================================================*/
