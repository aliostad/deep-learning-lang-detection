#ifndef _REPO_H_
#define _REPO_H_

#include <map>
#include <string>
#include <stdexcept>
#include <memory>

#include "module_interface.h"

#define MODULE(type_name) repo::instance().find<type_name>(#type_name)


class repo 
{
public:
  typedef std::shared_ptr<module_interface> module_ptr;

private:
  typedef std::map<std::string, module_ptr> map_type;

public:

  static repo& instance () 
  {
    static repo r;
    return r;
  }

  void insert (std::string const& name, module_ptr const& o)
  {
    map_[name] = o;
  }

  template <typename Module>
  Module& find (std::string const& name) const
  {
    map_type::const_iterator found = map_.find (name);
    if (found == map_.end ())
      throw std::runtime_error ("module: " + name + " does not available");

    return dynamic_cast<Module&> (*(found->second));
  }

private:
  map_type map_;

};

#endif // _YP_REPO_H_
