#!/usr/bin/env bash
#
# Copyright (c) STMicroelectronics 2014
#
# This file is part of repo-mirror.
#
# repo-mirror is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License v2.0
# as published by the Free Software Foundation
#
# repo-mirror is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# v2.0 along with repo-mirror. If not, see <http://www.gnu.org/licenses/>.
#

# unitary test

source `dirname $0`/common.sh

TEST_CASE="repo-mirror repo-mirror executed as is"

# Skip python 3 not supported by repo
! is_python3 || skip "python 3 not supported by repo"

# Generate a repo/git structure
$SRCDIR/tests/scripts/generate_repo.sh repos project1

# Repo init/sync and verify tree
mkdir -p local-repo-mirrors
mkdir -p test-repo

# Repo init/sync using local-repo-mirrors
mkdir -p repo-mirrors
mkdir -p test-repo
pushd local-repo-mirrors >/dev/null
$REPO_MIRROR -m "$TMPTEST/repo-mirrors" -d -q -- init -u file://"$TMPTEST"/repos/manifests.git --mirror </dev/null
$REPO_MIRROR -m "$TMPTEST/repo-mirrors" -d -q -- sync
popd >/dev/null

pushd test-repo >/dev/null
$REPO_MIRROR -m "$TMPTEST/repo-mirrors" -d -q -- init -u file://"$TMPTEST"/repos/manifests.git --reference="$TMPTEST/local-repo-mirrors" </dev/null
$REPO_MIRROR -m "$TMPTEST/repo-mirrors" -d -q -- sync
[ -f project1/README ]

# Verify that project have an alternate pointing to the user mirror
[ -f project1/.git/objects/info/alternates ]
[ "$(<project1/.git/objects/info/alternates)" = "$TMPTEST/local-repo-mirrors/project1.git/objects" ]

popd >/dev/null

