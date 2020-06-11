// Copyright 2015 Stefano Pogliani <stefano@spogliani.net>

#ifndef REPOSITORY_GIT_GIT_HPP
#define REPOSITORY_GIT_GIT_HPP

#include <git2.h>
#include <repositories/repository.h>


namespace sf {
namespace repository {

  class GitRepoVersion;

  //! Git backed repository.
  /*!
   * An instance of this class can be backed by a bare git
   * repository or a working directory.
   * 
   * A custom alias to resolve the <latest> version can be
   * specified, the default is master.
   */
  class GitRepo : public Repository {
    friend class GitRepoVersion;

   protected:
    std::string latest_alias;
    std::string path;
    git_repository* repo;

    //! Ensures that the repository is initialised.
    void ensure_repo_is_open();

    //! Resolves the given revision to a commit.
    git_commit* resolveCommit(std::string revision);

   public:
    GitRepo(std::string path, std::string latest="refs/heads/master");
    ~GitRepo();

    virtual RepositoryVersionRef latest();
    virtual RepositoryVersionRef version(std::string revision);

    virtual std::string resolveVersion(
        sf::state::Context context, const std::string version
    );
    virtual void verifyVersion(
        sf::state::Context context, const std::string version
    );
  };

  //! GitRepo version manager.
  class GitRepoVersion : public RepositoryVersion {
  protected:
    GitRepo*  repo;
    git_tree* tree;

   public:
    GitRepoVersion(GitRepo* repo, git_tree* tree);
    ~GitRepoVersion();

    virtual bool exists(const std::string path);
    virtual std::istream* streamFileRaw(const std::string path);
  };

}
}

#endif  // REPOSITORY_GIT_GIT_HPP
