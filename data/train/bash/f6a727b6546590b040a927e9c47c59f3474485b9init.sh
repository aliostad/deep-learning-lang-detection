#!/bin/bash
set -e

GIT_IS_LOCAL=$1
GIT_REPO_URL=$2
GIT_REPO_BRANCH=$3

echo "GIT_IS_LOCAL => $GIT_IS_LOCAL"
echo "GIT_REPO_URL => $GIT_REPO_URL"
echo "GIT_REPO_BRANCH => $GIT_REPO_BRANCH"

if $GIT_IS_LOCAL; then
  echo "git repo mounted from local ..."
  cmd="cd storm-quotactl-java && mvn test -P all"
else
  echo "git repo will be cloned from $GIT_REPO_URL, branch: $GIT_REPO_BRANCH"
  cmd="git clone $GIT_REPO_URL && cd storm-quotactl-java && git checkout $GIT_REPO_BRANCH && mvn test -P all"
fi

su - storm -c "whoami; id; $cmd"

echo "finished"