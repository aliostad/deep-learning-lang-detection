#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPODIR="${DIR}/../repos"

usage() {
cat <<EOF
Usage:
repos.sh update
repos.sh help
EOF
  exit 1
}

# this tool is designed for the user to have already sorted out what branch each repo
# is on and have committed any changes etc
cmd-updatecode-repo() {
  local repo=$1;

  if [[ ! -d "${REPODIR}/${repo}" ]]; then
    echo "cloning $repo"
    mkdir -p "${REPODIR}"
    cd ${REPODIR} && git clone "https://github.com/jenca-cloud/${repo}.git"
  fi

  cd "${REPODIR}/${repo}" && git pull
}

cmd-update() {
  cmd-updatecode-repo jenca-authorization
  cmd-updatecode-repo jenca-authentication
  cmd-updatecode-repo jenca-runtime
  cmd-updatecode-repo jenca-projects
  cmd-updatecode-repo jenca-library
  cmd-updatecode-repo jenca-router
  cmd-updatecode-repo jenca-gui
  cmd-updatecode-repo jenca-level-storage
}

main() {
  case "$1" in
  update)                 shift; cmd-update; $@;;
  *)                      usage $@;;
  esac
}

main "$@"
