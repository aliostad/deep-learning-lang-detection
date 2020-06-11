#!/bin/bash

#REPO_LREV=074a0aad8bf8ed2c08b318af4e0854dfbe29e312
#REPO_RREV=p-honeycomb-release
#REPO_PATH=frameworks/base
#REPO_PROJECT=platform/frameworks/base
#REPO_REMOTE=ohd-mirror

if [ -z "${REPO_PATH}" ]; then
  if [ ! -d .repo ]; then
      echo "This command needs to be run from a valid repo location."
      exit 1
  fi
  dir=$(dirname $0)
  script=$(basename $0)
  if [ ${dir} = '.' ]; then
      dir=$(pwd)
  fi
  .repo/repo/repo forall $* -c "${dir}/${script}"
  exit
fi

prefix=$(echo ${REPO_RREV}|cut -c 1-2)

if [ ${prefix} != "p-" ]; then
    echo "skip:${REPO_PROJECT}"
    exit
fi

official_branch=$(echo ${REPO_RREV}|cut -c 3-)

if ! git --no-pager log -1 --oneline ${REPO_REMOTE}/${official_branch} >/dev/null 2>&1; then
    echo "skip:${REPO_PROJECT}"
    exit
fi


parent=$(git merge-base ${REPO_REMOTE}/${official_branch} ${REPO_REMOTE}/${REPO_RREV})

echo "${parent}:${REPO_PROJECT}"
