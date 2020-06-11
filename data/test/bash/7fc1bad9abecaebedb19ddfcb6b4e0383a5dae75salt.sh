#!/usr/bin/env bash

echo "Add repo gpg key"
wget https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
rpm --import SALTSTACK-GPG-KEY.pub
rm -f SALTSTACK-GPG-KEY.pub

echo "Add SaltStack repo"
echo "[saltstack-repo]"                                                   > /etc/yum.repos.d/saltstack.repo
echo "name=SaltStack repo for RHEL/CentOS 7"                             >> /etc/yum.repos.d/saltstack.repo
echo "baseurl=https://repo.saltstack.com/yum/rhel7"                      >> /etc/yum.repos.d/saltstack.repo
echo "enabled=1"                                                         >> /etc/yum.repos.d/saltstack.repo
echo "gpgcheck=1"                                                        >> /etc/yum.repos.d/saltstack.repo
echo "gpgkey=https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub" >> /etc/yum.repos.d/saltstack.repo

echo "Install salt-master and salt-minion"
yum clean expire-cache
yum update
yum install -y salt-master salt-minion

echo "Disable salt-master service"
chkconfig salt-master off

echo "Disable salt-minion service"
chkconfig salt-minion off
