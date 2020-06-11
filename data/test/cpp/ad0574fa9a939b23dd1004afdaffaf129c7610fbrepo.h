//  Copyright © 2016 George Georgiev. All rights reserved.
//

#pragma once

#include "doim/fs/fs_directory.h"
#include "doim/url/url.h"
#include "err/err.h"
#include "im/initialization_manager.hpp"
#include "log/log.h"
#include "git/object.h"
#include <shared_ptr>
#include <git2.h> // IWYU pragma: keep
#include <stddef.h>

namespace git
{
class Repo
{
public:
    Repo(git_repository* repo);
    ~Repo();

    ECode parseRevision(const string& revision, ObjectSPtr& object);

    ECode checkout(const git::ObjectSPtr& object);

private:
    git_repository* mRepo = NULL;
};

typedef shared_ptr<Repo> RepoSPtr;
}
