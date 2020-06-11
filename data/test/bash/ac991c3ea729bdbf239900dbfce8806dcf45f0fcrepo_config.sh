#!/bin/bash

## create yum repo config file for this repo

set -e
set -x

. $( dirname $0 )/common

tmpdir=$( mktemp -d )
trap "echo removing ${tmpdir}; rm -rf ${tmpdir}" EXIT

PKG_NAME="${BUCKET}"
PKG_VER="1.0"

if ! pkg_exists_in_repo ${PKG_NAME}-${PKG_VER}; then
    repofile="/etc/yum.repos.d/${BUCKET}-${REPO}.repo"

    mkdir -p $( dirname ${tmpdir}/${repofile} )

    cat << EOF > ${tmpdir}/${repofile}
[${BUCKET}-${REPO}]
name=My S3 repo
baseurl=https://${BUCKET}.s3.amazonaws.com/${REPO}/
enabled=1
gpgcheck=0
EOF

    fpm \
        -s dir \
        -t rpm \
        -n ${PKG_NAME} \
        -v ${PKG_VER} \
        -a noarch \
        --description "Yum repo config for s3://${BUCKET}/${REPO}" \
        -C ${tmpdir} \
        ${repofile#/}
fi
