#!/bin/bash

ls -1d ~/hg/repo-sync-configs/build-* | grep -v 'build-slaveapi' | grep -v 'build-buildbot-configs' | while read repo_dir
do
    basename "${repo_dir}"
    cat "${repo_dir}/config" | grep 'url =' | sed 's/^[[:space:]]*//'
    cat "${repo_dir}/hgrc" | grep 'default =' | sed 's/^[[:space:]]*//'
done > aaa
ls -1d ~/hg/repo-sync-configs/build-* | grep -v 'build-slaveapi' | grep -v 'build-buildbot-configs' | while read repo_dir
do
    basename "${repo_dir}"
    echo "url = git@github.com:mozilla/$(basename "${repo_dir}").git"
    echo "default = http://hg.mozilla.org/build/$(basename "${repo_dir}" | sed 's/build-//')"
done > bbb

diff aaa bbb

ls -1d ~/hg/repo-sync-configs/build-* | grep -v 'build-slaveapi' | sed 's/.*\/build-//' | sort

