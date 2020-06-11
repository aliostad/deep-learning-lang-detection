#!/bin/bash
set -ev

export VERSION=${AZK_VERSION}
export DISTRO=precise
export REPO=azk-${DISTRO}

aptly repo create -distribution=${DISTRO} -component=main ${REPO}

# adding packages
aptly repo add -force-replace=true ${REPO} package/deb/azk_${VERSION}_amd64.deb

# wget https://github.com/azukiapp/libnss-resolver/releases/download/v0.2.1/ubuntu12-libnss-resolver_0.2.1_amd64.deb > package/deb/ubuntu12-libnss-resolver_0.2.1_amd64.deb
# package/deb/ubuntu12-libnss-resolver_0.2.1_amd64.deb

aptly repo show -with-packages ${REPO}

# snapshot
aptly snapshot list
aptly snapshot create ${REPO}-${VERSION} from repo ${REPO}

# publish list
aptly publish list

# publish snapshot
aptly publish snapshot ${REPO}-${VERSION}
aptly publish switch ${DISTRO} ${REPO}-${VERSION}
