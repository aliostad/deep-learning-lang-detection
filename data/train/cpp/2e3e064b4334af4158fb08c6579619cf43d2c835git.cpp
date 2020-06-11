#include <unistd.h>
#include <sys/param.h>
#include <stdlib.h>
#include <vector>
#include <algorithm>
#include <git2.h>

#include "color_code.h"
#include "color_combination.h"
#include "special_character.h"
#include "string_manipulation.h"

#include "git.h"

namespace git
{

#include "themes/default.cpp"

  class GitRepoStateSnapshot {

  public:
    GitRepoStateSnapshot(std::string &repoPath);
    ~GitRepoStateSnapshot() {
      if (currentBranchHandle)
	git_reference_free(currentBranchHandle);
      if (repoHandle)
	git_repository_free(repoHandle);
    }

    std::string getBranchName() const { return currentBranchName; }
    int getNumGenerationsAhead() const { return numCommitsAhead; }
    int getNumGenerationsBehind() const { return numCommitsBehind; }
    bool repoIsClean() const { return repoClean; }
    bool repoContainsUntrackedFiles() const {return containsUntrackedFiles; }
    bool isGitRepo() const { return gitRepoFound; }

  private:
    git_reference *currentBranchHandle = 0;
    git_repository *repoHandle = 0;
  
    size_t numCommitsAhead, numCommitsBehind;
    std::string currentBranchName;
    bool repoClean;
    bool containsUntrackedFiles;
    bool gitRepoFound;

    void openGitRepo(std::string &repoPath);
    void computeCurrentBranchName();
    void computeGenerationDelta();
    void computeRepoClean();
    int computeNumUntrackedFiles(git_status_list *status);

    git_commit *branchToCommit(git_reference *branch);
  };

  GitRepoStateSnapshot::GitRepoStateSnapshot(std::string &repoPath) {
    openGitRepo(repoPath);
    if (gitRepoFound) {
      computeCurrentBranchName();
      computeGenerationDelta();
      computeRepoClean();
    }
  }

  void GitRepoStateSnapshot::openGitRepo(std::string &repoPath) {
    int error = 0;
    while (repoPath.length() > 1) {
      error = git_repository_open(&repoHandle, repoPath.c_str());
      if (error >= 0) {
	gitRepoFound = true;
	return;
      }
      repoPath.erase(repoPath.rfind("/"));
    }
  }

  void GitRepoStateSnapshot::computeCurrentBranchName() {
    const char *branch_name;

    if (git_repository_head_detached(repoHandle)) {
      currentBranchHandle = nullptr;
      currentBranchName = "(detached head)";
      return;
    }

    int ret;
    ret = git_repository_head(&currentBranchHandle, repoHandle);
    if (ret) {
      currentBranchHandle = nullptr;
      currentBranchName = "(no branch)";
      return;
    }

    git_branch_name(&branch_name, currentBranchHandle);
    currentBranchName = branch_name;
  }

  void GitRepoStateSnapshot::computeGenerationDelta() {
    if (!currentBranchHandle) //detached head
      return;

    git_commit *localHead, *upstreamHead;
    
    int ret;
    git_reference *upstream;
    ret = git_branch_upstream(&upstream, currentBranchHandle);
    if (ret) {
      numCommitsAhead = 0;
      numCommitsBehind = 0;
      return;
    }

    localHead = branchToCommit(currentBranchHandle);
    upstreamHead = branchToCommit(upstream);

    const git_oid *localOid, *upstreamOid;
    localOid = git_commit_id(localHead);
    upstreamOid = git_commit_id(upstreamHead);

    // for some reason, a commit to the local repo is a commit *behind* for this function
    // TODO: More testing to make sure this works as intended
    git_graph_ahead_behind(&numCommitsBehind, &numCommitsAhead, repoHandle, localOid, upstreamOid);

    git_commit_free(localHead);
    git_commit_free(upstreamHead);
    git_reference_free(upstream);
  }

  git_commit *GitRepoStateSnapshot::branchToCommit(git_reference *branch) {
    int error = 0;
    
    git_object *commit_obj;
    error = git_reference_peel(&commit_obj, branch, GIT_OBJ_COMMIT);
    if (error) 
      return nullptr;

    const git_oid *oid = git_object_id(commit_obj);
    
    git_commit *commit;
    error = git_commit_lookup(&commit, repoHandle, oid);
    git_object_free(commit_obj);
    if (error)
      return nullptr;

    return commit;
  }

  void GitRepoStateSnapshot::computeRepoClean() {
    git_status_list *status;
    git_status_options opts;
    opts.version = GIT_STATUS_OPTIONS_VERSION;
    opts.flags = GIT_STATUS_OPT_INCLUDE_UNTRACKED;
    opts.show = GIT_STATUS_SHOW_INDEX_AND_WORKDIR;
    opts.pathspec.count = 0;

    git_status_list_new(&status, repoHandle, &opts);

    int modifiedCount = git_status_list_entrycount(status);
    int untrackedCount = computeNumUntrackedFiles(status);

    containsUntrackedFiles = (untrackedCount > 0);
    repoClean = (modifiedCount == untrackedCount);

    git_status_list_free(status);
  }

  int GitRepoStateSnapshot::computeNumUntrackedFiles(git_status_list *status) {
    const git_status_entry *entry;
    int num_entries = git_status_list_entrycount(status);
    int i, untrackedCount = 0;

    for (i = 0; i < num_entries; ++i) {
      entry = git_status_byindex(status, i);
      if (entry->status == GIT_STATUS_WT_NEW)
    	untrackedCount++;
    }

    return untrackedCount;
  }

  std::string getSegment()
  {
    char cpath[MAXPATHLEN];
    if( getcwd(cpath, sizeof(cpath)/sizeof(char)) == NULL )
      return std::string();

    std::string path = cpath;

    GitRepoStateSnapshot repoState(path);
    
    std::string *returnString = new std::string();

    if (repoState.isGitRepo()) {

      ColorCombination &separatorColors = repoState.repoIsClean() ? repo_clean_separator : repo_dirty_separator;
      ColorCombination &textColors = repoState.repoIsClean() ? repo_clean : repo_dirty;

      returnString->append(separatorColors.getColorCode());
      returnString->append(special("separator"));
      returnString->push_back(' ');

      returnString->append(textColors.getColorCode());
      
      returnString->append(special("git_branch"));
      returnString->push_back(' ');

      returnString->append(repoState.getBranchName());
      
      if (repoState.getNumGenerationsAhead() > 0) {
	returnString->push_back(' ');
	returnString->append(std::to_string(repoState.getNumGenerationsAhead()));
	returnString->append(special("git_ahead"));
      }
      if (repoState.getNumGenerationsBehind() > 0) {
	returnString->push_back(' ');
	returnString->append(std::to_string(repoState.getNumGenerationsBehind()));
	returnString->append(special("git_behind"));
      }

      if (repoState.repoContainsUntrackedFiles())
	returnString->append(" +");

      returnString->push_back(' ');
      separatorColors.inverse();
      returnString->append(separatorColors.getColorCode());
      returnString->append(special("separator"));
    }
    else {
      returnString->append(ColorCombination( &lightgray, &darkgray ).getColorCode());
      returnString->push_back(' ');
      returnString->append(special("separator_thin"));
      returnString->push_back(' ');
  }

  return *returnString;
  }
}

