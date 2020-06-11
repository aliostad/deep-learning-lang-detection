#!/bin/bash
#
# Reposync and Createrepo UPDATE script
#
# NOTES: Dont need to sync the OS cause once you have it for a 
# version, it doesnt change. In addition, creating the repo for it
# ususally breaks install groups. Lines for OS are included at the 
# bottom, for inclusiveness

# CentOS 5
# [fasttrack], [cr] and [contrib] have nothing in them so not bothering
reposync -n -p /opt/repo/centos/5/ --config=/etc/reposync.5.conf --repoid=os
reposync -n -p /opt/repo/centos/5/ --config=/etc/reposync.5.conf --repoid=updates
reposync -n -p /opt/repo/centos/5/ --config=/etc/reposync.5.conf --repoid=extras
reposync -n -p /opt/repo/centos/5/ --config=/etc/reposync.5.conf --repoid=centosplus
reposync -n -p /opt/repo/ --config=/etc/reposync.5.conf --repoid=epel5
reposync -n -p /opt/repo/vmtools/esxi5.1/ --config=/etc/reposync.5.conf --repoid=vmtools5
reposync -n -p /opt/repo/pagerduty/5/ --config=/etc/reposync.6.conf --repoid=pdagent

createrepo -d -s sha1 --update /opt/repo/centos/5/updates
createrepo -d -s sha1 --update /opt/repo/centos/5/extras
createrepo -d -s sha1 --update /opt/repo/centos/5/centosplus
createrepo -d -s sha1 --update /opt/repo/epel5
createrepo -d -s sha1 --update /opt/repo/vmtools/esxi5.1/vmtools5/
createrepo -d -s sha1 --update /opt/repo/pagerduty/5/

# Hadoop
reposync -n -p /opt/repo/cloudera/5/ --config=/etc/reposync.5.conf --repoid=cloudera
reposync -n -p /opt/repo/cloudera/5/ --config=/etc/reposync.5.conf --repoid=cloudera-manager

createrepo -d -s sha1 --update /opt/repo/cloudera/5/cloudera
createrepo -d -s sha1 --update /opt/repo/cloudera/5/cloudera-manager
createrepo -d -s sha1 --update /opt/repo/cloudera/extra/5

createrepo -d -s sha1 --update /opt/repo/hptools/5

# HP SPP
reposync -n -p /opt/repo/hptools/spp/5/ --config=/etc/reposync.5.conf --repoid=spp
createrepo -d -s sha1 --update /opt/repo/hptools/spp/5/

# Oracle Java
createrepo -d -s sha1 --update /opt/repo/oraclejava/5




# OS
#reposync -n -p /opt/repo/centos/5/ --config=/etc/reposync.5.conf --repoid=os
#createrepo -d -s sha1 --update -g /opt/repo/centos/5/os/repodata/comps.xml /opt/repo/centos/5/os
