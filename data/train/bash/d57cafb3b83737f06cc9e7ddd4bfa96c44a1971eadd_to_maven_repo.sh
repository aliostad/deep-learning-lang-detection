#!/bin/bash

# Fail Fast.
set -e

# Bail out if we're not running in Travis
if [ "${TRAVIS}" != "true" ]; then
    echo This script only designed to work within Travis CI
    exit 1;
fi

if [ -z "${BUILD_EMAIL}" ]; then
    echo Refusing to run because no email has been set.
    exit 2;
fi

# Setup minimum Git environment
git config --global user.email "${BUILD_EMAIL}"
git config --global user.name 'Travis CI'

if [ -z "${M2_REPO}" ]; then
    echo Refusing to run because no M2 repo dir has been defined.
    exit 3;
fi
DOC_REPO="${DOC_REPO:-${M2_REPO}}"

export M2_REPO_DIRECTORY="build/${M2_REPO}"
export DOC_REPO_DIRECTORY="build/${DOC_REPO}"

# clone the M2 Repository
echo Cloning "${M2_REPO}"...
git clone --quiet --depth 1 --branch master "https://${GH_TOKEN}@github.com/${M2_REPO}.git" "${M2_REPO_DIRECTORY}" >/dev/null 2>&1
echo "${M2_REPO}" cloned successfully.

# if necessary, clone the doc repository
if [ "$M2_REPO" != "$DOC_REPO" ]; then
    echo Cloning "${DOC_REPO}"...
    git clone --quiet --depth 1 --branch master "https://${GH_TOKEN}@github.com/${DOC_REPO}.git" "${DOC_REPO_DIRECTORY}" >/dev/null 2>&1
    echo "${DOC_REPO}" cloned successfully.
fi

# Push the maven artifacts into the right part of the tree
./gradlew uploadArchives

# copy any docs
if [ -d build/docs/javadoc ]; then
    JAVADOC_DEST_DIR="${DOC_REPO_DIRECTORY}/.docs/${TRAVIS_REPO_SLUG}/${TRAVIS_TAG}"
    test ! -d "${JAVADOC_DEST_DIR}" && mkdir -p "${JAVADOC_DEST_DIR}"
    cp -Rv build/docs/javadoc "${JAVADOC_DEST_DIR/javadoc}"
fi

if [ -d build/docs/groovydoc ]; then
    GROOVYDOC_DEST_DIR="${DOC_REPO_DIRECTORY}/.docs/${TRAVIS_REPO_SLUG}/${TRAVIS_TAG}"
    test ! -d "${GROOVYDOC_DEST_DIR}" && mkdir -p "${GROOVYDOC_DEST_DIR}"
    cp -Rv build/docs/groovydoc "${GROOVYDOC_DEST_DIR/javadoc}"
fi

# switch into our checked out M2 Repo clone
pushd "${M2_REPO_DIRECTORY}"
# regenerate the .m2 repo index
./reindex.sh -d .m2
git add .m2
popd

pushd "${DOC_REPO_DIRECTORY}"
#regenerate the java/groovy docs index
./reindex.sh -d .docs -l 3
git add .docs
popd

# commit and push our changes back to the .m2 site
pushd "${M2_REPO_DIRECTORY}"
git commit -m "Publishing ${TRAVIS_REPO_SLUG}@${TRAVIS_TAG}"
git push --quiet "https://${GH_TOKEN}@github.com/${M2_REPO}.git" master:master >/dev/null 2>&1

# if a different repo, push changes back to the .docs site
if [ "$M2_REPO" != "$DOC_REPO" ]; then
    popd
    pushd "${DOC_REPO_DIRECTORY}"
    git commit -m "Publishing ${TRAVIS_REPO_SLUG}@${TRAVIS_TAG}"
    git push --quiet "https://${GH_TOKEN}@github.com/${DOC_REPO}.git" master:master >/dev/null 2>&1
fi
