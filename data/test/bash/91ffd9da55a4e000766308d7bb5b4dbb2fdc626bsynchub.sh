#! /bin/bash

#GIT_MIRROR_IP=192.168.122.20
#REMOTE_REPO_NAME=localMirror
GIT_MIRROR_IP=192.168.1.181
REMOTE_REPO_NAME=mirror

repoList="devstack horizon keystone python-keystoneclient glance python-glanceclient nova python-novaclient cinder python-cinderclient quantum python-quantumclient noVNC tempest swift python-openstackclient python-swiftclient python-ceilometerclient ceilometer heat python-heatclient"

GITHUB_DIR=/local/github

function checkStatus {
    for repo in ${repoList};do
        echo "${repo}"
        cd ${GITHUB_DIR}/${repo}
        git st
    done
}

function mirrorCfg {
    for repo in ${repoList};do
        cat << DONE_${repo}
repo    ${repo}
        RW+     =   @all
        R       =   daemon
${repo} "Owner" = "Test repo"

DONE_${repo}
    done
}

function syncMirror {
    for repo in ${repoList};do
        echo "${repo}"
        cd ${GITHUB_DIR}/${repo}
        git co master
        git remote add ${REMOTE_REPO_NAME} gitolite@${GIT_MIRROR_IP}:${repo}.git
        git st
        git pull
        git push ${REMOTE_REPO_NAME} master
    done
}

checkStatus
mirrorCfg
syncMirror
