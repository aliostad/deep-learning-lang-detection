#!/bin/bash

if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.orig ]; then
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.orig
fi
rm -f /etc/yum.repos.d/CentOS-Base.repo
cp local-CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

# create local repo
cat << __EOT__ > /etc/yum.repos.d/local-epel.repo
[local-epel]
name=local-epel
baseurl=file:///opt/local-repo/epel
enabled=1
priority=1
gpgcheck=0
__EOT__

cat << __EOT__ > /etc/yum.repos.d/local-openstack-icehouse.repo
[local-openstack-icehouse]
name=local-openstack-icehouse
baseurl=file:///opt/local-repo/openstack-icehouse
enabled=1
priority=1
gpgcheck=0
__EOT__

yum clean all
yum repolist

