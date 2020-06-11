/* -*-c++-*- OpenFDM - Copyright (C) 2004-2010 Mathias Froehlich 
 *
 */

#include "XMLReader.h"

namespace OpenFDM {
namespace XML {

XMLReader::~XMLReader(void)
{
}

ContentHandler*
XMLReader::getContentHandler(void) const
{
  const ContentHandler* ch = mContentHandler;
  return const_cast<ContentHandler*>(ch);
}

void
XMLReader::setContentHandler(ContentHandler* contentHandler)
{
  mContentHandler = contentHandler;
}

ErrorHandler*
XMLReader::getErrorHandler(void) const
{
  const ErrorHandler* eh = mErrorHandler;
  return const_cast<ErrorHandler*>(eh);
}

void
XMLReader::setErrorHandler(ErrorHandler* errorHandler)
{
  mErrorHandler = errorHandler;
}

} // namespace XML
} // namespace OpenFDM
