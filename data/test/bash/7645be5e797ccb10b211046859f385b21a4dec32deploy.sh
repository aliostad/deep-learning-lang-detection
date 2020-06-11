#!/usr/bin/env bash

set -e

if [ -z "${TRAVIS_TAG}" ]; then
  QUAY_TAG="${TRAVIS_COMMIT:0:7}"
else
  QUAY_TAG="${TRAVIS_TAG}"

  docker tag -f "quay.io/${TRAVIS_REPO_SLUG:0:6}/${TRAVIS_REPO_SLUG:14}:${TRAVIS_COMMIT:0:7}" "quay.io/${TRAVIS_REPO_SLUG:0:6}/${TRAVIS_REPO_SLUG:14}:${QUAY_TAG}"
fi

docker push "quay.io/${TRAVIS_REPO_SLUG:0:6}/${TRAVIS_REPO_SLUG:14}:${QUAY_TAG}"
docker tag -f "quay.io/${TRAVIS_REPO_SLUG:0:6}/${TRAVIS_REPO_SLUG:14}:${QUAY_TAG}" "quay.io/${TRAVIS_REPO_SLUG:0:6}/${TRAVIS_REPO_SLUG:14}:latest"
docker push "quay.io/${TRAVIS_REPO_SLUG:0:6}/${TRAVIS_REPO_SLUG:14}:latest"
