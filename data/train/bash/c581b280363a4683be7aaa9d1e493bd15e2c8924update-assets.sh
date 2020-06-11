#!/bin/bash
set -e

copy_frontend() {
  repo="$1"
  app="$2"

  rm -rf "static/$app"
  mkdir -p "static/$app"
  cp -r tmp/"$repo"/frontend/build/prod/* "static/$app/"
}

update_repo() {
  repo="$1"

  echo "updating $repo"
  cd "$repo"

  git reset --hard
  git checkout master
  git pull
  version=$(git tag --list | sort -rn | head -n 1)
  git checkout -B "tags/$version"

  cd ..
}

cd tmp

update_repo "homecam"
update_repo "browserphone"

cd ..

copy_frontend "homecam" "hc"
copy_frontend "browserphone" "phone"
