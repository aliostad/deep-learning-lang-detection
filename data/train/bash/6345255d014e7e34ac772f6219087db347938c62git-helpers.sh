#!/bin/bash

function _extract_repo_dir {
  local repo=${1##*/}
  echo ${repo%.git}
}

function _get_git_clone_params {
  local url=$1
  local dir="$2"
  local repo_dir="$(_extract_repo_dir $url)"

  echo -n "$url "
  if [ -z "$dir" ]; then
    echo "$repo_dir"
  elif [[ "$dir" == */ ]]; then
    echo "${dir}${repo_dir}"
  else
    echo "$dir"
  fi
}

function _generate_git_clone_params {
  while read line; do
    if [[ "$line" == \#* || -z "$line" ]]; then
      continue # skip comments
    fi
    _get_git_clone_params $line
  done
}

function gclone {
  _generate_git_clone_params < $1 | parallel $2 --colsep=" " git clone
}
