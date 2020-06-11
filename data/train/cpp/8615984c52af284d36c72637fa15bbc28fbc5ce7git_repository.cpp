#include "git_repository.h"

GitRepository::GitRepository(git_repository* repo) :
  repo(repo)
{
}

GitRepository::GitRepository(GitRepository&& other)
{
  this->repo = other.repo;
  other.repo = NULL;
}

GitRepository& GitRepository::operator=(GitRepository&& other)
{
  this->repo = other.repo;
  other.repo = NULL;
  return *this;
}

GitRepository::~GitRepository()
{
  git_repository_free(repo);
}

const git_repository* GitRepository::get_repo() const
{
  return repo;
}

GitReference GitRepository::get_head_reference()
{
  git_reference* ref = NULL;

  int error = git_repository_head(&ref, repo);

  if (error != 0)
  {
    //TODO - Throw an exception here.
  }

  GitReference reference(ref);

  return reference;
}

GitCommit GitRepository::commit_lookup(GitObjectID& oid)
{
  git_commit* commit_p = NULL;
  git_commit_lookup(&commit_p, this->repo, oid.oid);

  GitCommit commit(commit_p);
  return commit;
}


/* static */ GitRepository GitRepository::init_or_clone_repo(
    std::string url,
    std::string path)
{
  git_repository* repo;

  int error = git_repository_open(&repo, path.c_str());

  if (error != 0)
  {
    int clone_error = git_clone(&repo, url.c_str(), path.c_str(), NULL);
    if (clone_error != 0)
    {
      //TODO - throw an exception here.
    }
  }

  GitRepository repository(repo);
  return repository;
}
