#include <assert.h>
#include <iostream>
#include <memory>
#include <string>

#include <git2.h>

#include "gitxx.h"

using std::cout;
using std::endl;
using std::string;
using std::unique_ptr;

void CatRevision(gitxx::Repository& repo) {
  unique_ptr<gitxx::Object> o(repo.GetRevision("0555eda802f9e00038118828cbce1891ef789c58"));
  string b(o->GetBlobContent());

  cout << b << endl;
  assert(b ==
	 "This is a directory just to make tests pass.\n");
}

void DumpCommitTree(gitxx::Repository& repo, const string& rev) {
  unique_ptr<gitxx::Object> o(repo.GetRevision(rev));
  unique_ptr<gitxx::Tree> t(o->GetTreeFromCommit());
  t->dump("");
}

int main() {
  gitxx::Repository repo(".");
  CatRevision(repo);
  DumpCommitTree(repo, "HEAD");
  DumpCommitTree(repo, "70a926d68853b09e304b75e5b39c77c0b42e889b");
}

