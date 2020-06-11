#!/bin/bash
#
#
#  Don't forget that reposync create the downloaded repo in a 
#  dir called ${repo}, hence the tempdir and symlink
#

PATH=/bin:/sbin:/usr/bin:/usr/sbin

CONFDIR=./conf
# REPOROOT=/export/repos
REPOROOT=/hcom/repos
TEMPDIR=$(mktemp -d)

scriptdir=$(cd $(dirname "$0") && pwd)
conffile=${scriptdir}/conf/reposync.conf
arch=x86_64

function log_start {
    start_time=$1
    repo=$2
    repodir=${3}
    ymd=$(date +%Y-%m-%d)

    printf "====================================================================\n"
    printf "Started ${repo} at ${ymd} ${start_time}\n"
    printf "Copying ${repo} repo to ${repodir}/${repo}\n"
    printf "====================================================================\n\n"
}

function log_end {
    start_time=$1
    repo=$2
    repodir=${3}
    ymd=$(date +%Y-%m-%d)
    end_time=$(date +%H:%M:%S)

    printf "\n====================================================================\n"
    printf "Started ${repo} at ${ymd} ${start_time}\n"
    printf "Copied ${repo} repo to ${repodir}/${repo}\n"
    printf "Completed ${repo} at ${ymd} ${end_time}\n"
    printf "====================================================================\n\n"
}

function rsync_repo {
    printf ""
}

function wget_repo {
    printf ""
}

function reposync_repo {
    app=$1
    repo=$2
    repodir=$3

    start_hms=$(date +%H:%M:%S)
    log_start ${start_hms} ${repo} ${repodir}

    echo reposync --config=${conffile} --repoid=${repo} --download_path=${repodir}
    reposync --config=${conffile} --repoid=${repo} --download_path=${repodir}

    echo createrepo -v -d ${repodir}/${repo}
    createrepo -v -d ${repodir}/${repo}

    log_end ${start_hms} ${repo} ${repodir}
}

if [ ! -f ${conffile} ]; then
    printf "Unable to find ${conffile}\n"
    printf "Exiting.\n"
    exit 1
fi

case $1 in
    centos)
        #  Originally tried to reposync the base OS, but creatrepo did weird
        #  things to repodata, esp regarding groups, so we only reposync
        #  updates now
        app=$1
        release=$2
        stack=$3
        major_release=${release}

        case ${release} in
            5.10)
                ;;
            6.5)
                ;;
            7)
                release=7.0
                ;;
            7.0)
                major_release=7
                ;;
            *)
                printf "\nUnsupported version of ${app} - ${release}\n\n"
                exit 1
                ;;
        esac

        case ${stack} in
            extras)
                mkdir -p ${REPOROOT}/${app}/${app}-${major_release}/extras/${arch}/
                ln -sfn ${REPOROOT}/${app}/${app}-${major_release}/extras/${arch}/ ${TEMPDIR}/${app}-${release}-${arch}-extras
                reposync_repo ${app} ${app}-${release}-${arch}-extras ${TEMPDIR}
                rm -Rf ${TEMPDIR}
                ;;
            *)
                # default to updating updates
                mkdir -p ${REPOROOT}/${app}/${app}-${major_release}/updates/${arch}/
                ln -sfn ${REPOROOT}/${app}/${app}-${major_release}/updates/${arch}/ ${TEMPDIR}/${app}-${release}-${arch}-updates
                reposync_repo ${app} ${app}-${release}-${arch}-updates ${TEMPDIR}
                rm -Rf ${TEMPDIR}
                ;;
        esac
        ;;
    epel)
        app=$1
        release=$2
        reposync_repo ${app} ${app}-${release}-${arch} ${REPOROOT}/${app}
        ;;
    *)
        printf "need OS version.\n"
        exit 1
        ;;
esac  
