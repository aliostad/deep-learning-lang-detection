//  Copyright © 2016 George Georgiev. All rights reserved.
//

#include "git/git.h"
#include "doim/fs/fs_directory.h"
#include "doim/url/url.h"
#include "err/err.h"
#include "err/gtest/err.h"
#include "gtest/test_resource.h"
#include <gtest/gtest.h>
#include <boost/filesystem/operations.hpp>
#include <memory>
#include <str>

TEST(GitTest, SLOW_initRepo)
{
    auto repoDir = doim::FsDirectory::obtain(testing::gTempDirectory, "init_repo");
    boost::filesystem::remove_all(repoDir->path().c_str());

    git::RepoSPtr repo;
    ASSERT_OKAY(git::gMgr->initRepo(repoDir, repo));
    ASSERT_NE(nullptr, repo);
}

TEST(GitTest, SLOW_openRepo)
{
    auto repoDir = doim::FsDirectory::obtain(testing::gTempDirectory, "open_repo");
    boost::filesystem::remove_all(repoDir->path().c_str());

    git::RepoSPtr repo;
    ASSERT_OKAY(git::gMgr->initRepo(repoDir, repo));
    ASSERT_OKAY(git::gMgr->openRepo(repoDir, repo));
    ASSERT_NE(nullptr, repo);
}

TEST(GitTest, INTEGRATION_cloneRepo)
{
    auto repoDir = doim::FsDirectory::obtain(testing::gTempDirectory, "clone_repo");
    boost::filesystem::remove_all(repoDir->path().c_str());

    auto url = doim::Url::make("https://github.com/ggeorgiev/dev-scripts.git");

    git::RepoSPtr repo;
    ASSERT_OKAY(git::gMgr->cloneRepo(url, repoDir, repo));
    ASSERT_NE(nullptr, repo);
}
