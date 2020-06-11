#!/bin/sh

set -x
set -e

repo=$(cat ./bower.json | grep -E "name\":" | sed 's/.*name": "\([^"]*\).*/\1/')

rm -rf ./bower_components
bower install
bower install polymerelements/iron-ajax#^0.9.0

git subtree add -P $repo origin gh-pages

rm -rf ./$repo/*

cp -r ./bower_components/* ./$repo

cp ./element-page-tools/index.html ./$repo
cp ./element-page-tools/element-gallery.html ./$repo
cp ./bower.json ./$repo

if [ -d "./demo" ]; then
  mkdir -p ./$repo/combined
  cp -r ./demo ./$repo/combined
fi

git add .
git commit -m "Automated gh-pages deployment."

git subtree push -P $repo origin gh-pages
git reset --hard origin/master

rm -rf ./$repo

set +x
set +e
