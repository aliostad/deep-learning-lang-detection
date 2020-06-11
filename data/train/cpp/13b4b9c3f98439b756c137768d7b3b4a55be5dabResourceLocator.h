/*
 * ResourceLocator.h
 *
 *
 *  Created on: Aug 17, 2011
 *      Author: Martin Uhrin
 */

#ifndef RESOURCE_LOCATOR_H
#define RESOURCE_LOCATOR_H

// INCLUDES /////////////////////////////////////////////
#include "SSLib.h"

#include <ostream>
#include <string>

#include <boost/filesystem.hpp>


// FORWARD DECLARATIONS ////////////////////////////////////


namespace sstbx {
namespace io {

class ResourceLocator
{
public:
  static const ::std::string ID_DELIMITER;

  ResourceLocator();
  /* implicit */ ResourceLocator(const ::boost::filesystem::path & path);
  ResourceLocator(const ::boost::filesystem::path & path, const ::std::string & resourceId);

  bool set(const ::std::string & locatorString);

  ::std::string string() const;

  const ::boost::filesystem::path & path() const;
  void setPath(const ::boost::filesystem::path & path);

  const ::std::string & id() const;
  void setId(const ::std::string & resourceId);

  bool empty() const;

  ResourceLocator & operator =(const ResourceLocator & rhs);

  ResourceLocator & makeRelative(const ::boost::filesystem::path & from);

private:

  ::boost::filesystem::path myPath;
  ::std::string myResourceId;
};

ResourceLocator absolute(const ResourceLocator & loc);

ResourceLocator relative(const ResourceLocator & to);

ResourceLocator relative(const ResourceLocator & from, const ResourceLocator & to);

::std::ostream & operator <<(::std::ostream & os, const ResourceLocator & loc);

inline bool operator<(const ResourceLocator & lhs, const ResourceLocator & rhs)
{
  return lhs.string() < rhs.string();
}

}
}

#endif /* RESOURCE_LOCATOR_H */
