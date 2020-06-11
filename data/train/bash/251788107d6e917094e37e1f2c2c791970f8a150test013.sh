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

TEST_CASE="repo-mirror with specific encodings"

# Skip python 3 not supported by repo
! is_python3 || skip "python 3 not supported by repo"

# Generate a repo/git structure
$SRCDIR/tests/scripts/generate_repo.sh repos project1 project2 project1-1:project1/project1-1

# Repo init/sync and verify tree
mkdir -p repo-mirrors
mkdir -p test-repo
cd test-repo
cat >repo_utf8 <<EOF
#!/bin/sh
echo "Excuting repo with some utf8 encoding: éè 年 月 日 星期三"
repo \${1+"\$@"}
EOF
chmod +x repo_utf8

# Run with locale set to utf8
env LANG=en_US.utf8 LC_ALL=en_US.utf8 $REPO_MIRROR -r $PWD/repo_utf8 -m "$TMPTEST/repo-mirrors" -d -q -- init -u file://"$TMPTEST"/repos/manifests.git </dev/null
env LANG=en_US.utf8 LC_ALL=en_US.utf8 $REPO_MIRROR -r $PWD/repo_utf8 -m "$TMPTEST/repo-mirrors" -d -q -- sync

# Run with locale set to C
env LANG=C LC_ALL=C $REPO_MIRROR -r $PWD/repo_utf8 -m "$TMPTEST/repo-mirrors" -d -q -- init -u file://"$TMPTEST"/repos/manifests.git </dev/null
env LANG=C LC_ALL=C $REPO_MIRROR -r $PWD/repo_utf8 -m "$TMPTEST/repo-mirrors" -d -q -- sync
