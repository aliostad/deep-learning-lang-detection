// Copyright 2015 Stefano Pogliani <stefano@spogliani.net>
#include <gtest/gtest.h>
#include <list>

#include "state/context.h"

#include "repositories/git/git.hpp"
#include "repositories/git/internal/error.hpp"

#include "testing/options.h"

using sf::exception::ErrNoException;
using sf::exception::GitException;
using sf::exception::GitInvalidVersion;
using sf::repository::GitRepo;


const std::string FIXTURE_PATH = "daemon/repositories/git/tests/fixture";
const std::string NOT_COMMIT   = "0000000393468508e310fef2af3ea38ae6e37db5";

const std::string HEAD_COMMIT   = "e95e542924181262f9daa1184f643b35d692c94d";
const std::string MASTER_COMMIT = "e95e542924181262f9daa1184f643b35d692c94d";
const std::string TAG_COMMIT    = "838d4743042253b9a13e07c8d4f92fa8b67ae474";
const std::string HEAD_TREE     = "4f03abc970fc0eb74c9b19a380d10ed0de5f8b54";


class GitRepoTest : public ::testing::Test {
 protected:
  std::string cwd;
  std::list<GitRepo*> repos;

  // Fixtures for context and such.
  sf::testing::TestOptions options;
  sf::state::StaticContext static_context;
  sf::state::Context context;

 public:
  GitRepoTest() :
      static_context(sf::state::newStaticContext(options)),
      context(sf::state::newContext(static_context)) {
    git_libgit2_init();

    char* cwd = get_current_dir_name();
    this->cwd = std::string(cwd);
    free(cwd);
  }

  ~GitRepoTest() {
    std::list<GitRepo*>::iterator it;
    for (it = this->repos.begin(); it != this->repos.end(); it++) {
      delete *it;
    }
  }

  GitRepo* make(std::string path="<cwd>") {
    if (path == "<cwd>") {
      path = this->cwd;
    }

    GitRepo* repo = new GitRepo(path);
    this->repos.push_back(repo);
    return repo;
  }

  GitRepo* getFixture() {
    return this->make(FIXTURE_PATH);
  }
};


TEST_F(GitRepoTest, RepoNotFound) {
  GitRepo* repo = this->make("not a valid repo");
  ASSERT_THROW(repo->latest(), GitException);
}

TEST_F(GitRepoTest, PathNotFound) {
  GitRepo* repo = this->getFixture();
  ASSERT_FALSE(repo->latest()->exists("path does not exists"));
}

TEST_F(GitRepoTest, PathExists) {
  GitRepo* repo = this->getFixture();
  ASSERT_TRUE(repo->latest()->exists("exists"));
}

TEST_F(GitRepoTest, CommitToItself) {
  GitRepo* repo = this->getFixture();
  std::string head = repo->resolveVersion(this->context, HEAD_COMMIT);
  ASSERT_EQ(HEAD_COMMIT, head);
}

TEST_F(GitRepoTest, ResolveHead) {
  GitRepo* repo = this->getFixture();
  std::string head = repo->resolveVersion(this->context, "HEAD");
  ASSERT_EQ(HEAD_COMMIT, head);
}

TEST_F(GitRepoTest, ResolveMaster) {
  GitRepo* repo = this->getFixture();
  std::string master = repo->resolveVersion(this->context, "master");
  ASSERT_EQ(MASTER_COMMIT, master);
}

TEST_F(GitRepoTest, ResolveMasterLong) {
  GitRepo* repo = this->getFixture();
  std::string master = repo->resolveVersion(this->context, "refs/heads/master");
  ASSERT_EQ(MASTER_COMMIT, master);
}

TEST_F(GitRepoTest, ResolveTag) {
  GitRepo* repo = this->getFixture();
  std::string tag = repo->resolveVersion(this->context, "tag");
  ASSERT_EQ(TAG_COMMIT, tag);
}

TEST_F(GitRepoTest, VerifyCommitNotFound) {
  GitRepo* repo = this->getFixture();
  ASSERT_THROW(
      repo->verifyVersion(this->context, NOT_COMMIT),
      GitInvalidVersion
  );
}

TEST_F(GitRepoTest, VerifyCommitValid) {
  GitRepo* repo = this->getFixture();
  repo->verifyVersion(this->context, HEAD_COMMIT);
}

TEST_F(GitRepoTest, VerifyFailWithTree) {
  GitRepo* repo = this->getFixture();
  ASSERT_THROW(
      repo->verifyVersion(this->context, HEAD_TREE),
      GitInvalidVersion
  );
}

TEST_F(GitRepoTest, StreamFileRawForTag) {
  GitRepo* repo = this->getFixture();
  std::istream* stream = repo->version("tag")->streamFileRaw("exists");
  ASSERT_NE(nullptr, stream);

  int ch = stream->get();
  EXPECT_EQ(-1, ch);
  EXPECT_TRUE(stream->eof());

  delete stream;
}

TEST_F(GitRepoTest, StreamFileRaw) {
  GitRepo* repo = this->getFixture();
  std::istream* stream = repo->latest()->streamFileRaw("content");
  ASSERT_NE(nullptr, stream);

  std::string line;
  std::getline(*stream, line);
  EXPECT_EQ("File with some content", line);

  delete stream;
}
