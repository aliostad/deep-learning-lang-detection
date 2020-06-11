#!/bin/bash
# sbrepocombinator v. 0.0.3
# Combine multiple slackbuild-repositories into one 'local' for sbopkg.

# Copyright (c) 2014 Thomas Szteliga <ts@websafe.pl>, <https://websafe.pl/>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

## -----------------------------------------------------------------------------

#
set -e

#
IFS="
"

#
TMP=/tmp/sbrepocombinator
LOCAL_REPO_ROOT=${LOCAL_REPO_ROOT:-$TMP/local}
REPOS_CONFIG=${REPOS_CONFIG:-/etc/sbrepocombinator/repos.conf}

## -----------------------------------------------------------------------------

# Clone all configured repos
for row in $(grep -vE "^#" ${REPOS_CONFIG});
do
  repo_name=$(echo $row | cut -f1)
  repo_uri=$(echo $row | cut -f2)
  repo_branch=$(echo $row | cut -f3)
  #
  if [ -d "${TMP}/repo-${repo_name}" ];
  then
    rm -rfv "${TMP}/repo-${repo_name}"
  fi
  mkdir -p "${TMP}/repo-${repo_name}"
  git clone -b ${repo_branch} \
    ${repo_uri} \
    "${TMP}/repo-${repo_name}/${repo_branch}"
  echo -e "\n\n"
done

# Extract main repositories data
main_repo_name=$(grep -vE "^#" ${REPOS_CONFIG} | head -n1 | cut -f1)
main_repo_uri=$(grep -vE "^#" ${REPOS_CONFIG} | head -n1 | cut -f2)
main_repo_branch=$(grep -vE "^#" ${REPOS_CONFIG} | head -n1 | cut -f3)

# Prepare directory for the combined local repository
if [ -d "${LOCAL_REPO_ROOT}" ];
then
  rm -rf "${LOCAL_REPO_ROOT}"
fi
mkdir -p "${LOCAL_REPO_ROOT}"

# Copy main repo to local
cp -ar \
  ${TMP}/repo-${main_repo_name}/${main_repo_branch}/* \
  "${LOCAL_REPO_ROOT}/"

# Cleanup local repo
rm -rfv \
  "${LOCAL_REPO_ROOT}/.git" \
  "${LOCAL_REPO_ROOT}/.gitignore" \
  "${LOCAL_REPO_ROOT}/.mailmap" \
  "${LOCAL_REPO_ROOT}/ChangeLog.txt" \
  "${LOCAL_REPO_ROOT}/README"

# Iterate all cloned repos except the main one (first)
for repos_row in `grep -vP "^(#|${main_repo_name}\t)" ${REPOS_CONFIG}`;
do
  #
  modified_repo_name=$(echo $repos_row | cut -f1)
  modified_repo_uri=$(echo $repos_row | cut -f2)
  modified_repo_branch=$(echo $repos_row | cut -f3)
  # Retrieve a list of all directories in current repo containing a slackbuild
  modified_slackbuilds_locations=$(
    find "${TMP}/repo-${modified_repo_name}/${modified_repo_branch}" \
      -type f -name "*.info" -exec dirname '{}' \;
  )
  # Iterate
  for modified_slackbuild_location in ${modified_slackbuilds_locations};
  do
    # Extract the package name from the location
    slackbuild=$(basename "${modified_slackbuild_location}")
    #
    local_slackbuild_location=$(
      find "${LOCAL_REPO_ROOT}/" \
        -type f -name "${slackbuild}.info" -exec dirname '{}' \;
    )
    #
    if [ ! -z "${local_slackbuild_location}" ];
    then
      cp -arv \
        ${modified_slackbuild_location}/* \
        ${local_slackbuild_location}/
    else
      if [ ! -d "${LOCAL_REPO_ROOT}/${modified_repo_name}" ];
      then
        mkdir -p "${LOCAL_REPO_ROOT}/${modified_repo_name}";
      fi;
      cp -arv \
        ${modified_slackbuild_location} \
        "${LOCAL_REPO_ROOT}/${modified_repo_name}/"
    fi
    echo -e "\n\n"
  done
done

#
exit 0
