#!/usr/bin/env bash

bare_clone() {
    local SOURCE_ORG_OR_USER="$1";
    local SOURCE_REPO="$2";

    SOURCE_REPO_URL="https://github.com/${SOURCE_ORG_OR_USER}/${SOURCE_REPO}.git"

    echo "Source repo URL is ${SOURCE_REPO_URL}" >&2

    git clone --bare ${SOURCE_REPO_URL}
}

mirror_push() {

    local TARGET_ORG_OR_USER="$1";
    local TARGET_REPO="$2";

    PUSH_TARGET_REPO="git@github.com:${TARGET_ORG_OR_USER}/${TARGET_REPO}.git"

    echo "Push repo URL is ${PUSH_TARGET_REPO}" >&2

    git push --mirror $PUSH_TARGET_REPO
}

while getopts ":u:r:" opt; do
  case $opt in
    u)
      USER_OR_ORG=$OPTARG
      echo "source user is $USER_OR_ORG" >&2
      ;;
    r)
      REPO=$OPTARG
      echo "source repo is $REPO" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

bare_clone $USER_OR_ORG $REPO

cd $REPO.git

for student in {1..20}
do
    student_user_id="student${student}"
    push_repo="${student_user_id}_lab"
    mirror_push C3IDigitalLiteracyLab $push_repo
done
