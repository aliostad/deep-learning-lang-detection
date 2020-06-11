#!/bin/bash

sudo mkdir /etc/yum.repos.d/repo.disabled
sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repo.disabled
sudo /vagrant/fedora-server_16_64/fedora16.repo /etc/yum.repos.d/fedora16.repo

sudo chown -Rf vagrant:vagrant /etc/yum.repos.d
sudo echo '[Fedora16-Repository]' > /etc/yum.repos.d/fedora16.repo
sudo echo 'name=DVD-Fedora16 Repository' >> /etc/yum.repos.d/fedora16.repo
sudo echo 'baseurl=http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/16/Fedora/x86_64/os/' >> /etc/yum.repos.d/fedora16.repo
sudo echo 'enabled=1' >> /etc/yum.repos.d/fedora16.repo
sudo echo 'gpgcheck=0' >> /etc/yum.repos.d/fedora16.repo
sudo chown -Rf root:root /etc/yum.repos.d

exit

# EOF
