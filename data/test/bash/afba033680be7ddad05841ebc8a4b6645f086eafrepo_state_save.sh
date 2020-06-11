#! /bin/bash

# This script can operate on a subset of projects.

# There are two modes to support: mirror, and non-mirror mode.
function isRepoMirror() {
    grep -A1 repo.mirror .repo/manifests.git/.repo_config.json | grep -Pzo '(?s)repo.mirror":.*?\"true\"' > /dev/null
    return $?
}

isRepoMirror
if [[ $? == 0 ]]; then
    # This is a repo mirror
    repo forall "$@" -c 'echo $REPO_PATH; echo $REPO_LREV'
else
    # This a classical repo checkout
    repo forall "$@" -c 'echo $REPO_PATH; git rev-parse HEAD'
fi
