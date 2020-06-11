#!/bin/bash

# Script to download and build latest blaze dependencies.

set -e

source git_functions.sh

WORK=${HOME}/workspace
APPS=${WORK}/apps

BLAZE_REPOS="libdynd dynd-python blz datashape blaze"
GITHUB_ORG=ContinuumIO
GITHUB_USER=aterrel
GITHUB_TEAM="mwiebe mrocklin talumbau ${GITHUB_ORG}"

get_repo_dir(){
    echo ${APPS}/$1/$1-dev
}

get_repo_url(){
    user=${1}
    repo=${2}
    echo git@github.com:${user}/${repo}.git
}

git_clone_repos() {
    for repo in ${BLAZE_REPOS}; do
        repo_dir=`get_repo_dir ${repo}`
        if [ ! -d ${repo_dir}/.git ]; then
            echo "Cloning ${repo} into ${repo_dir}"
            git clone `get_repo_url ${GITHUB_ORG} ${repo}` ${repo_dir}
            pushd ${repo_dir} > /dev/null
            hub create ${repo} || true
            git remote set-url origin `get_repo_url ${GITHUB_USER} ${repo}`
        fi
        pushd ${repo_dir} > /dev/null
        for mate in ${GITHUB_TEAM}; do
            if git remote | xargs echo | grep -v -q ${mate}; then
                git remote add ${mate} `get_repo_url ${mate} ${repo}`
                git fetch ${mate} || git remote remove ${mate}
            fi
        done
        popd > /dev/null
    done
}

git_update_repos() {
    for repo in $BLAZE_REPOS; do
        repo_dir=`get_repo_dir ${repo}`
        echo "Pulling ${repo}"
        pushd ${repo_dir} > /dev/null
        local branch_name=`git_branchname`
        local dirty=`git_dirty`
        if [ $dirty == 1 ]; then
            echo "STASHING"
            git stash
        fi
        git checkout master
        git fetch --all
        git pull ${GITHUB_ORG} master
        git push origin master
        git checkout ${branch_name}
        if [ $dirty == 1 ]; then
            git stash pop
        fi
        popd > /dev/null
    done
}

build_libdynd() {
    repo=libdynd
    repo_dir=`get_repo_dir ${repo}`
    build_dir=${repo_dir}/build
    cd ${repo_dir}
    git clean -fdx
    mkdir -p ${build_dir}
    cd ${build_dir}
    cmake -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_FLAGS="-stdlib=libc++"  ..
    make
    mkdir -p ../lib
    cp libdynd* ../lib
    chmod +x libdynd-config
}

build_dynd_python(){
    repo=dynd-python
    repo_dir=`get_repo_dir ${repo}`
    build_dir=${repo_dir}/build
    rm -rf ${build_dir}
    mkdir -p ${build_dir}
    cd ${build_dir}
    cmake -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_FLAGS="-stdlib=libc++" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DUSE_SEPARATE_LIBDYND=ON -DCMAKE_INSTALL_PREFIX=${PWD} -DPYTHON_PACKAGE_INSTALL_PREFIX=${PWD} ..
    make
    make install
}

build_blz(){
    repo=blz
    repo_dir=`get_repo_dir ${repo}`
    cd ${repo_dir}
    git clean -fdx
    python setup.py build_ext --inplace
    python setup.py install --prefix=${PWD}
}

build_datashape(){
    echo "No build needed"
}

build_blaze(){
    repo=blaze
    repo_dir=`get_repo_dir ${repo}`
    cd ${repo_dir}
    python setup.py install --prefix=${PWD}
}

build_blaze_stack(){
    build_libdynd
    build_dynd_python
    build_blz
    build_datashape
    build_blaze
}

#   git_clone_repos
#git_update_repos
build_blaze_stack
