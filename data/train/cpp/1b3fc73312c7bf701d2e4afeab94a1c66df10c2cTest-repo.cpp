
#include <assert.h>
#include <QString>
#include <QDebug>
#include <gtest/gtest.h>

#include "Repository.h"
#include "IBranches.h"
#include "Branch.h"
#include "../tap.h"

class RepoTest : public testing::Test
{
protected:
    virtual void SetUp()
    {
        system("cp -r ../testrepo/ ../tmptestrepo/");
    }

    virtual void TearDown() {
        system("rm -rf ../tmptestrepo/");
    }

    AcGit::Repository *repo;
};


TEST_F(RepoTest, test_repo) {

    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);
}

TEST_F(RepoTest, explicit_git_test_repo) {

    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo/.git");

    ASSERT_TRUE (repo != nullptr);
}

TEST_F(RepoTest, explicit_git_test_folder_does_not_exist) {

    AcGit::Repository *repo;

    EXPECT_THROW(repo  = new AcGit::Repository("../tmptestrepo.git"), AcGit::GitException);
}


TEST_F(RepoTest, down_folder_test_repo) {
    system("mkdir -p ../tmptestrepo/newfolder");
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo/newfolder/");

    ASSERT_TRUE (repo != nullptr);
}

TEST_F(RepoTest, explicit_down_folder_git_test_repo_does_not_exist) {
    system("mkdir -p ../tmptestrepo/newfolder");

    AcGit::Repository *repo;

    EXPECT_THROW(repo = new AcGit::Repository("../tmptestrepo/newfolder/.git"), AcGit::GitException);
}

TEST_F(RepoTest, test_for_BranchAgent) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);
    AcGit::IBranches *branchAgent = repo->BranchAgent();
    ASSERT_TRUE(branchAgent != nullptr);
}

TEST_F(RepoTest, test_for_TagsAgent) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);
    AcGit::ITags *tagsAgent = repo->TagsAgent();
    ASSERT_TRUE(tagsAgent != nullptr);
}

TEST_F(RepoTest, test_for_CommitsAgent) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);
    AcGit::ICommits *commitsAgent = repo->CommitsAgent();
    ASSERT_TRUE(commitsAgent != nullptr);
}


TEST_F(RepoTest, test_for_hasWorkingTreeChangesTrue) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);
    bool hasWorkingTreeChanges = repo->HasWorkingTreeChanges();

    EXPECT_EQ(hasWorkingTreeChanges, true);
}

TEST_F(RepoTest, test_for_hasAHeadCommit) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);

    AcGit::Commit *commit = repo->HeadCommit();

    ASSERT_TRUE(commit != nullptr);
}

TEST_F(RepoTest, test_for_ConfigurationAgent) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);

    AcGit::Configuration *config = repo->ConfigurationAgent();

    ASSERT_TRUE(config != nullptr);
}

TEST_F(RepoTest, test_for_topLevelDirectory) {
    AcGit::Repository *repo = new AcGit::Repository("../tmptestrepo");

    ASSERT_TRUE (repo != nullptr);

    QString dir = repo->GitTopLevelDirectory();

    EXPECT_EQ(dir.endsWith("tmptestrepo/.git/"), true);
}



int main (int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    testing::TestEventListeners& listeners = testing::UnitTest::GetInstance()->listeners();

    // Delete the default listener
    delete listeners.Release(listeners.default_result_printer());
    listeners.Append(new tap::TapListener());

    return RUN_ALL_TESTS();
}
