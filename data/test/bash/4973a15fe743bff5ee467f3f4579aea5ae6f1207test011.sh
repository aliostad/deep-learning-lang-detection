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

TEST_CASE="repo-mirror repo mirror alternates not in .repo"

# Skip python 3 not supported by repo
! is_python3 || skip "python 3 not supported by repo"

# Generate a repo/git structure
$SRCDIR/tests/scripts/generate_repo.sh repos project1 project2 project1-1:project1/project1-1

# Repo init/sync and verify tree with repo-mirror
mkdir -p repo-mirrors
mkdir -p test-repo
cd test-repo
$REPO_MIRROR -m "$TMPTEST/repo-mirrors" -d -q -- init -u file://"$TMPTEST"/repos/manifests.git </dev/null

# Verify that all alternates point to actual mirrored gits and not in .repo
# temporary dir.
# In particular the behavior as of repo 1.21 is that the manifests alternates
# point to <repo_mirror>/.repo/manigests.git instead of <repo_mirror>/manifests.git
# in some cases.
# For this we simply remove the .repo in the mirror dir in case it is still there
# and verify that all alternates dir are valid directories.
rm -rf $TMPTEST/repo-mirrors/default/repos/.repo
alternates="$(find . -name alternates)"
for i in $alternates; do
    alternate="$(<$i)"
    [ -d "$alternate" ] || exit 1
done

