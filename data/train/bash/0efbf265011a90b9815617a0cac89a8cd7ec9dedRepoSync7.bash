#!/bin/bash
#
# Reposync and Createrepo UPDATE script
#
# NOTES: Dont need to sync the OS cause once you have it for a 
# version, it doesnt change. In addition, creating the repo for it
# ususally breaks install groups. Lines for OS are included at the 
# bottom, for inclusiveness

# CentOS 7
# [cr] repo isnt on the mirrors anymore
# [contrib] repo isnt on the mirrors anymore
# [scl] repo isnt on the mirrors anymore
reposync -n -p /opt/repo/centos/7/ --config=/etc/reposync.7.conf --repoid=updates
reposync -n -p /opt/repo/centos/7/ --config=/etc/reposync.7.conf --repoid=extras
reposync -n -p /opt/repo/centos/7/ --config=/etc/reposync.7.conf --repoid=centosplus
reposync -n -p /opt/repo/centos/7/ --config=/etc/reposync.7.conf --repoid=fasttrack

createrepo --update /opt/repo/centos/7/updates/
createrepo --update /opt/repo/centos/7/extras/
createrepo --update /opt/repo/centos/7/centosplus/
createrepo --update /opt/repo/centos/7/fasttrack/

# EPEL 7
reposync -n -p /opt/repo/ --config=/etc/reposync.7.conf --repoid=epel7
createrepo --update /opt/repo/epel7/

# PostgreSQL 9.3
reposync -n -p /opt/repo/postgresql/7/ --config=/etc/reposync.7.conf --repoid=postgresql93
createrepo --update /opt/repo/postgresql/7/postgresql93/

# VMWare Tools - as of 11DEC2014, no 7 rpms---try 6 rpms?
reposync -n -p /opt/repo/vmtools/esxi5.1/ --config=/etc/reposync.7.conf --repoid=vmtools7
createrepo --update /opt/repo/vmtools/esxi5.1/vmtools7/

# HP SPP
reposync -n -p /opt/repo/hptools/spp/7/ --config=/etc/reposync.7.conf --repoid=spp
createrepo --update /opt/repo/hptools/spp/7/

# Mesos
reposync -n -p /opt/repo/mesos/7/ --config=/etc/reposync.7.conf --repoid=mesos
#reposync -n -p /opt/repo/mesos-noarch/7/ --config=/etc/reposync.7.conf --repoid=mesos-noarch # only has public repo file rpm
#reposync -n -p /opt/repo/mesos-source/7/ --config=/etc/reposync.7.conf --repoid=mesos-source
createrepo --update /opt/repo/mesos/7/
#createrepo --update /opt/repo/mesos-noarch/7/
#createrepo --update /opt/repo/mesos-source/7/


# OS
#reposync -n -p /opt/repo/centos/7/ --config=/etc/reposync.7.conf --repoid=os
#createrepo -g /opt/repo/centos/7/os/repodata/c7-minimal-x86_64-comps.xml --update /opt/repo/centos/7/os/

