//  Copyright © 2016 George Georgiev. All rights reserved.
//

#include "git/git.h"
#include "git/err.h"
#include <functional>
#include <str>

namespace git
{
MgrSPtr gMgr = im::InitializationManager::subscribe(gMgr);

Mgr::Mgr()
{
    git_libgit2_init();
}

Mgr::~Mgr()
{
    git_libgit2_shutdown();
}

ECode Mgr::initRepo(const doim::FsDirectorySPtr& repoDir, RepoSPtr& repo)
{
    git_repository* raw;
    EHGitTest(git_repository_init(&raw, repoDir->path().c_str(), false));
    repo = std::make_shared<Repo>(raw);
    EHEnd;
}

ECode Mgr::openRepo(const doim::FsDirectorySPtr& repoDir, RepoSPtr& repo)
{
    git_repository* raw;
    EHGitTest(git_repository_open(&raw, repoDir->path().c_str()));
    repo = std::make_shared<Repo>(raw);
    EHEnd;
}

ECode Mgr::cloneRepo(const doim::UrlSPtr& url,
                     const doim::FsDirectorySPtr& repoDir,
                     RepoSPtr& repo)
{
    git_repository* raw;
    EHGitTest(git_clone(&raw, url->path().c_str(), repoDir->path().c_str(), nullptr));
    repo = std::make_shared<Repo>(raw);
    EHEnd;
}

} // namespace git
