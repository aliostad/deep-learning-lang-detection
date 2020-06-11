/*
 * ResourceLocator.cpp
 *
 *  Created on: Aug 18, 2011
 *      Author: muhrin
 */

// INCLUDES //////////////////////////////////
#include "io/ResourceLocator.h"

#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>

// Local includes
#include <io/BoostFilesystem.h>

// NAMESPACES ////////////////////////////////

namespace sstbx {
namespace io {

namespace fs = ::boost::filesystem;
namespace algorithm = ::boost::algorithm;

const ::std::string ResourceLocator::ID_DELIMITER = "#";

ResourceLocator::ResourceLocator()
{}

ResourceLocator::ResourceLocator(const fs::path & path):
myPath(path)
{}

ResourceLocator::ResourceLocator(const fs::path & path, const ::std::string & resourceId):
myPath(path),
myResourceId(resourceId)
{}

bool ResourceLocator::set(const ::std::string & locatorString)
{
  typedef ::std::vector< ::std::string> SplitVector;

  if(locatorString.empty())
    return false;

  fs::path newPath;
  ::std::string newResourceId;
    
  SplitVector splitStrings;
  algorithm::split(splitStrings, locatorString, algorithm::is_any_of(ID_DELIMITER));

  if(splitStrings.size() > 2)
    return false;
  else if(splitStrings.size() == 2)
    newResourceId = splitStrings[1];

  newPath = fs::path(splitStrings[0]);

  // TODO: Probably worthwhile to do check on path and resource id here
  
  setPath(newPath);
  if(!newResourceId.empty())
    setId(newResourceId);

  return true;
}

::std::string ResourceLocator::string() const
{
  ::std::string str = myPath.string();
  if(!myResourceId.empty())
    str += ID_DELIMITER + myResourceId;
  return str;
}

const fs::path & ResourceLocator::path() const
{
  return myPath;
}

void ResourceLocator::setPath(const fs::path & path)
{
  myPath = path;
}

const ::std::string & ResourceLocator::id() const
{
  return myResourceId;
}

void ResourceLocator::setId(const ::std::string & resourceId)
{
  myResourceId = resourceId;
}

bool ResourceLocator::empty() const
{
  return myPath.empty() && myResourceId.empty();
}

ResourceLocator & ResourceLocator::operator =(const ResourceLocator & rhs)
{
  setPath(rhs.path());
  setId(rhs.id());
  return *this;
}

ResourceLocator &
ResourceLocator::makeRelative(const ::boost::filesystem::path & from)
{
  myPath = make_relative(from, myPath);
  return *this;
}

bool equivalent(const ResourceLocator & loc1, const ResourceLocator & loc2)
{
  return fs::equivalent(loc1.path(), loc2.path()) && loc1.id() == loc2.id();
}

ResourceLocator absolute(const ResourceLocator & loc)
{
  return ResourceLocator(io::absolute(loc.path()), loc.id());
}

ResourceLocator relative(const ResourceLocator & to)
{
  return relative(ResourceLocator(fs::current_path()), to);
}

ResourceLocator relative(const ResourceLocator & from, const ResourceLocator & to)
{
  return ResourceLocator(io::make_relative(from.path(), to.path()), to.id());
}

::std::ostream & operator <<(::std::ostream & os, const ResourceLocator & loc)
{
  os << loc.string();
  return os;
}

}
}
