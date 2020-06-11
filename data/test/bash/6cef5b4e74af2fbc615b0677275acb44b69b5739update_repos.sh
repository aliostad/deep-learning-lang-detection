#!/bin/bash

if [ "$1" == "--base-images" ]; then
  base_images="true"
fi

pull_and_update_hg () {

echo "======== /hg/packages ========="
hg --cwd /hg/packages pull
hg --cwd /hg/packages update null
echo "*** starting pull and update on /highland/packages ***"
echo "======== /highland/packages ========="
hg --cwd /highland/packages pull
hg --cwd /highland/packages update && echo "*** update-archive.sh has finished running ***" & 

for repo in $(ls /hg); do
  if [ "$repo" == "packages" ]; then
    continue
  fi
  if [ -f /hg/${repo}/.hg/hgrc ]; then
    echo "======== /hg/${repo} ========="
    hg --cwd /hg/${repo} pull
    hg --cwd /hg/${repo} update null
    # run in background for better performance
  fi
done

}

pull_and_update_hg_base () {

for repo in $(ls /hg/base-images); do
  if [ -f /hg/base-images/${repo}/.hg/hgrc ]; then
    echo "======== /hg/base-images/${repo} ========="
    hg --cwd /hg/base-images/${repo} pull
    hg --cwd /hg/base-images/${repo} update
  fi
done

for repo in $(ls /highland); do
  if [ -f /highland/${repo}/.hg/hgrc ]; then
    if [ "$repo" == "packages" -o "$repo" == "private" ]; then
      continue
    else
      echo "======== /highland/${repo} ========="
      hg --cwd /highland/${repo} pull
      hg --cwd /highland/${repo} update
    fi
  fi
done

}

pull_and_update_highland () {

for repo in $(ls /highland); do
  if [ -f /highland/${repo}/.hg/hgrc ]; then
    if [ "$repo" == "packages" -o "$repo" == "private" ]; then
      continue
    else
      echo "======== /highland/${repo} ========="
      hg --cwd /highland/${repo} pull
      hg --cwd /highland/${repo} update
    fi
  fi
done

}

pull_and_update_hg
if [ -n "$base_images" ]; then
  pull_update_hg_base
fi
pull_and_update_highland
wait
