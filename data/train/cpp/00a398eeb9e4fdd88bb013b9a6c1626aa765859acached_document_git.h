#ifndef __CACHED_DOCUMENT_GIT_H__
#define __CACHED_DOCUMENT_GIT_H__

#include <git2.h>
#include <boost/shared_ptr.hpp>
#include "cached_document.h"

namespace gld {
  class GitRepo;
  
  class CachedDocumentGit : public CachedDocument {
    public:
      CachedDocumentGit(GeanyDocument* geany_document, boost::shared_ptr<GitRepo> repo_ptr);
      ~CachedDocumentGit(void);

      void cache(void);

      static CachedDocumentGit* attempt_create(GeanyDocument* doc);

      boost::shared_ptr<GitRepo> repo;
      void check_source(void);
      bool is_latest(void);

      git_oid oid;
  };

  class GitRepo {
    public:
      GitRepo(const std::string& repo_path);
      ~GitRepo(void);

      bool check_head(void);
      std::string path(void);
      git_object* find_file(const std::string& path);
      void get_file(const std::string& path, std::string& str);

    //private:
    
      git_repository* repo;
      git_oid head_oid;
  };
}

#endif

