#! /bin/bash -e

VERSION="$(jq -r '.PackageVersion' .goxc.json)"
BRANCHNAME="$(jq -r '.BranchName' .goxc.json)"
PRERELEASEINFO="$(jq -r '.PrereleaseInfo' .goxc.json)"
BUILDNAME="$(jq -r '.BuildName' .goxc.json)"
GH_USER="$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 1)"
GH_REPO="$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 2)"
NAME="v${VERSION}-${BRANCHNAME}.${PRERELEASEINFO}+b${BUILDNAME}"

if github-release info --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" | grep "^- v${VERSION}"; then
    echo "The tag v${VERSION} already exists"
    exit 1
fi

echo "Creating a new draft release ${NAME}"

github-release release --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "${NAME}" --draft --description "Built by Travis-ci.org"

for F in $(find ${GOPATH}/bin/${GH_REPO}-xc/${VERSION}-* -type 'f' -name '*.tar.gz'); do
    echo "Uploading ${F}"

    github-release upload --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "$(basename ${F})" -f ${F}
done

echo "Removing the draft status on tag ${NAME}"

github-release edit --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "${NAME}" --description "Built by Travis-ci.org"
