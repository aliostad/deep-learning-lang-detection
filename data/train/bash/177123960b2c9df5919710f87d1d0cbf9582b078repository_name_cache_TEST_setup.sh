#!/usr/bin/env bash
# vim: set ft=sh sw=4 sts=4 et :

mkdir repository_name_cache_TEST_dir || exit 1
cd repository_name_cache_TEST_dir || exit 1

mkdir -p not_generated
mkdir -p generated

mkdir -p old_format/repo
echo "paludis-1" > old_format/repo/_VERSION_

mkdir -p bad_repo/repo
echo "paludis-2" > bad_repo/repo/_VERSION_
echo "monkey" >> bad_repo/repo/_VERSION_

mkdir -p good_repo/repo
echo "paludis-2" > good_repo/repo/_VERSION_
echo "repo" >> good_repo/repo/_VERSION_
echo "bar" > good_repo/repo/foo
echo "baz" >> good_repo/repo/foo

