#!/usr/bin/env bash

set -e

export PERL5LIB=$PWD/lib

ILSM=(
  ingydotnet/inline-c-pm
  daoswald/Inline-CPP
)

main() {
  for repo in ${ILSM[@]}; do
    echo "Testing '$repo'"
    check-repo || continue
    (
      set -x
      cd "$repo_path"
      if [ -e Meta ]; then
        make test
        make cpantest
        make disttest
      else
        perl Makefile.PL < /dev/null
        make test
        make purge
      fi
    )
  done
  echo "All ILSM tests passed!"
}

check-repo() {
  repo_path="test/devel/repo/${repo#*/}"
  if [ ! -e "$repo_path" ]; then
    mkdir -p test/devel
    git clone "git@github.com:$repo" "$repo_path"
  else
    (
      set -x
      cd "$repo_path"
      branch="$(git rev-parse --abbrev-ref HEAD)"
      if [ "$branch" != master ]; then
        echo "Repo '$repo_path' is not on master"
      fi
      git reset --hard
      git clean -fxd
      if [ -n "$(git status -s)" ]; then
        die "Repo '$repo_path' is not clean"
      fi
      git pull --rebase origin master
    ) || return 1
  fi
  return 0
}

die() {
  echo "$@"
  exit 1
}

[ "$BASH_SOURCE" == "$0" ] && main "$@"

:
