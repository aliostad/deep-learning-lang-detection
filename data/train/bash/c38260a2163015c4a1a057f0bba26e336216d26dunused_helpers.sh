#!/bin/bash

function valid_repo () {
  [ -d "$1" ] && [ -d "$1/app" ]
}

function abort_message () {
    exec 1>&2
    echo "'$1' is not a valid repository"
    echo "Usage: ./unused_helpers <repository_path>"
}

function helper_methods () {
  local dir="$1"
  echo $(grep -Erh "^[^#]*def \w+.*$" "${dir}/app/helpers/" | sed 's/.*def // ; s/(.*//')
}

function method_being_used () {
  local repo="$1" method="$2"
  local occurrences=$(ack "[^#]*${method}" "${repo}/app" | wc -l)
  occurrences=$(($occurrences + $(ack "[^#]*${method}" "${repo}/structure" --ignore-dir=assets | wc -l)))

  [ $occurrences -gt 1 ]
}

function list_unused_helpers () {
  local repo="$1"
  for method in $(helper_methods "$repo"); do
    if ! method_being_used "$repo" "$method"; then
      echo $method
    fi
  done
}

function run () {
  local repo="$1"

  if valid_repo "$repo"; then
    list_unused_helpers "$repo"
  else
    abort_message "$repo"
    exit 1
  fi
}

run "$@"
