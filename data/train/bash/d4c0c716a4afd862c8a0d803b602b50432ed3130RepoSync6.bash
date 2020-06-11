#!/bin/bash
#
# Reposync and Createrepo UPDATE script
#
# NOTES: Dont need to sync the OS cause once you have it for a 
# version, it doesnt change. In addition, creating the repo for it
# ususally breaks install groups. Lines for OS are included at the 
# bottom, for inclusiveness

# CentOS 6
# [cr] repo isnt on the mirrors anymore
reposync -n -p /opt/repo --config=/etc/reposync.6.conf --repoid=cloudstack
reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=updates
reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=extras
reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=contrib
reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=centosplus
reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=fasttrack
reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=scl
reposync -n -p /opt/repo/ --config=/etc/reposync.6.conf --repoid=epel6
reposync -n -p /opt/repo/ --config=/etc/reposync.6.conf --repoid=theforeman
reposync -n -p /opt/repo/vmtools/esxi5.1/ --config=/etc/reposync.6.conf --repoid=vmtools6
reposync -n -p /opt/repo/postgresql/6/ --config=/etc/reposync.6.conf --repoid=pgdg91
reposync -n -p /opt/repo/postgresql/6/ --config=/etc/reposync.6.conf --repoid=pgdg93
reposync -n -p /opt/repo/pagerduty/6/ --config=/etc/reposync.6.conf --repoid=pdagent
reposync -n -p /opt/repo/ --config=/etc/reposync.6.conf --repoid=newrelic

createrepo --update /opt/repo/cloudstack/
createrepo --update /opt/repo/epel6/
createrepo --update /opt/repo/centos/6/updates/
createrepo --update /opt/repo/centos/6/extras/
createrepo --update /opt/repo/centos/6/contrib/
createrepo --update /opt/repo/centos/6/centosplus/
createrepo --update /opt/repo/centos/6/fasttrack/
createrepo --update /opt/repo/centos/6/scl/
createrepo --update /opt/repo/theforeman/
createrepo --update /opt/repo/vmtools/esxi5.1/vmtools6/
createrepo --update /opt/repo/postgresql/6/pgdg91/
createrepo --update /opt/repo/postgresql/6/pgdg93/
createrepo --update /opt/repo/pagerduty/6/
createrepo --update /opt/repo/newrelic/

# cloudera for rhel6
reposync -n -p /opt/repo/cloudera/6/ --config=/etc/reposync.6.conf --repoid=cloudera
reposync -n -p /opt/repo/cloudera/6/ --config=/etc/reposync.6.conf --repoid=cloudera-manager
reposync -n -p /opt/repo/cloudera/6/ --config=/etc/reposync.6.conf --repoid=cloudera-impala

createrepo --update /opt/repo/cloudera/6/cloudera/
createrepo --update /opt/repo/cloudera/6/cloudera-manager/
createrepo --update /opt/repo/cloudera/6/cloudera-impala/
createrepo --update /opt/repo/cloudera/extra/6/

# CentOS 6.5 32bit
reposync -n -p /opt/repo/centos/6-32bit/ --config=/etc/reposync.6-32bit.conf --repoid=updates65-32
reposync -n -p /opt/repo/ --config=/etc/reposync.6-32bit.conf --repoid=epel6-32bit
reposync -n -p /opt/repo/vmtools/esxi5.1/ --config=/etc/reposync.6-32bit.conf --repoid=vmtools6-32bit

createrepo --update /opt/repo/centos/6-32bit/updates65-32/
createrepo --update /opt/repo/epel6-32bit/
createrepo --update /opt/repo/vmtools/esxi5.1/vmtools6-32bit/

# HP SPP
reposync -n -p /opt/repo/hptools/spp/6/ --config=/etc/reposync.6.conf --repoid=spp
createrepo --update /opt/repo/hptools/spp/6/

# OS
#reposync -n -p /opt/repo/centos/6/ --config=/etc/reposync.6.conf --repoid=os
#createrepo -g /opt/repo/centos/6/os/repodata/c6-x86_64-comps.xml --update /opt/repo/centos/6/os/

#32bit CentOS 6.5
#reposync -n -p /opt/repo/centos/6-32bit/ --config=/etc/reposync.6-32bit.conf --repoid=os65-32
#createrepo -g /opt/repo/centos/6-32bit/os65-32/repodata/c6-i386-comps.xml --update /opt/repo/centos/6-32bit/os65-32/
