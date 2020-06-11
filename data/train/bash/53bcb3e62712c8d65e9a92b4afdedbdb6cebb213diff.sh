#!/bin/bash -x

set -e

bin_path=$(dirname $0)

if [ ! -d .repo/versions ]; then
  mkdir .repo/versions
  cd .repo/versions
  git init > /dev/null
  cd ../..
fi

${bin_path}/repo forall -p -c git rev-parse HEAD > .repo/versions/ver.txt

if [ -f .repo/versions/.git/refs/heads/master ]; then
  git --git-dir .repo/versions/.git cat-file -p HEAD:ver.txt | awk -f ${bin_path}/diff.awk /dev/stdin .repo/versions/ver.txt
else
  echo "-------------------------------------------------"
  echo "[INIT VERSION]"
  echo "-------------------------------------------------"
fi
