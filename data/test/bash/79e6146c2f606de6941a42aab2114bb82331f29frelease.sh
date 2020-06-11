#!/bin/bash

if [ "$APPVEYOR_REPO_TAG" == "true" ]; then

  echo "Shipping a release for $APPVEYOR_REPO_TAG_NAME"

  curl -s -L -o github-release.zip https://github.com/aktau/github-release/releases/download/v0.5.2/windows-amd64-github-release.zip

  unzip github-release.zip

  bin/windows/amd64/github-release.exe release \
    --user jamesward \
    --repo gulp-launcher \
    --tag $APPVEYOR_REPO_TAG_NAME

  chmod +x bash/gulp

  bin/windows/amd64/github-release.exe upload \
    --user jamesward \
    --repo gulp-launcher \
    --tag $APPVEYOR_REPO_TAG_NAME \
    --name "gulp" \
    --file bash/gulp

  bin/windows/amd64/github-release.exe upload \
    --user jamesward \
    --repo gulp-launcher \
    --tag $APPVEYOR_REPO_TAG_NAME \
    --name "gulp.exe" \
    --file python/dist/gulp.exe

fi
