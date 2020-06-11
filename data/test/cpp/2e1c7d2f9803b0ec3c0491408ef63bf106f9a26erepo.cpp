#include "gtest/gtest.h"
#include "Commit.h"
#include "Repository.h"
#include "Reference.h"
#include "GitException.h"

TEST(repo, failure) {
  ASSERT_THROW(Repository("/tmp/notfound"), GitException);
}

TEST(repo, success) {
  Repository repo("../test/testrepo");
  ASSERT_TRUE(true); // No exception
  Repository rep(repo);
  rep = repo;
}

TEST(repo, get) {
  Repository repo("../test/testrepo");
  git_repository* bare = repo.get();
  ASSERT_NE(bare, nullptr);
}

TEST(repo, head) {
  Repository repo("../test/testrepo");
  Reference head = repo.head();
  ASSERT_NE(head.get(), nullptr);
  ASSERT_EQ(head.name(), "refs/heads/master");
}


TEST(repo, commits) {
  Repository repo("../test/testrepo");
  ASSERT_EQ(repo.getAllCommits().size(), 4);
}


TEST(repo, commitx) {
  Repository repo("../test/testrepo");
  auto commits = repo.getAllCommitsX();
  ASSERT_EQ(commits[0]->getAuthor(), "Tim Siebels"); 
  ASSERT_EQ(commits[0]->getAuthorMail(), "tim_siebels_aurich@yahoo.de");
  ASSERT_EQ(commits[0]->getFiles().size(), 2);  
  ASSERT_EQ(commits[0]->getFiles()[0].filename, "file.txt");
  ASSERT_EQ(commits[0]->getFiles()[0].linesChanged, 1);
}

TEST(repo, commitx_since_after) {
  Repository repo("../test/testrepo");
  auto commits = repo.getAllCommitsX(1452021601);
  ASSERT_EQ(commits.size(), 2);
  commits = repo.getAllCommitsX(0, 1443092500);
  ASSERT_EQ(commits.size(), 2);
}
