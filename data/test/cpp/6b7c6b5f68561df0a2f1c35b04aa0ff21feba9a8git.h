//  Copyright © 2016 George Georgiev. All rights reserved.
//

#pragma once

#include "doim/fs/fs_directory.h"
#include "doim/url/url.h"
#include "err/err.h"
#include "im/initialization_manager.hpp"
#include "log/log.h"
#include "git/repo.h"
#include <shared_ptr>
#include <git2.h> // IWYU pragma: keep
#include <stddef.h>

namespace git
{
class Mgr;
typedef shared_ptr<Mgr> MgrSPtr;

class Mgr
{
public:
    static constexpr int rank()
    {
        return dbslog::rank() + im::InitializationManager::step();
    }
    Mgr();
    ~Mgr();

    ECode initRepo(const doim::FsDirectorySPtr& repoDir, RepoSPtr& repo);
    ECode openRepo(const doim::FsDirectorySPtr& repoDir, RepoSPtr& repo);
    ECode cloneRepo(const doim::UrlSPtr& url,
                    const doim::FsDirectorySPtr& repoDir,
                    RepoSPtr& repo);
};

extern MgrSPtr gMgr;
}
