#!/bin/bash

readonly WORKSPACE=`pwd`
# readonly BUILD_NUMBER=$2
# readonly BUILD_ID=$3

readonly TMP_DIR=tmp
readonly REPO_DIR=repo
readonly SITE_DIR=build/html
readonly REPO_URL="git@github.com:sousk/sphinx-demo.git"
readonly BRANCH="gh-pages"

mkdir -p "${WORKSPACE}/${TMP_DIR}"
cd       "${WORKSPACE}/${TMP_DIR}"

if [ -e "${WORKSPACE}/${TMP_DIR}/${REPO_DIR}" ]; then
  cd "${WORKSPACE}/${TMP_DIR}/${REPO_DIR}"
  git checkout ${BRANCH}
  git pull origin ${BRANCH}
else
  git clone ${REPO_URL} --branch ${BRANCH} ${REPO_DIR}
  cd "${WORKSPACE}/${TMP_DIR}/${REPO_DIR}"
fi

rm -rf "${WORKSPACE}/${TMP_DIR}/${REPO_DIR}/${SITE_DIR}/*"
cp -r  "${WORKSPACE}/${SITE_DIR}/" .
touch ".nojekyll"

git add .
git commit -am "build by script"

git push origin ${BRANCH}
