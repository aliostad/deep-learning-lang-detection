#!/bin/bash
mv /etc/yum.repos.d/* /var/tmp/
echo "
[server-repo]
name=centosos-6.5
baseurl=http://172.28.128.1/repo/centos-6.5/
gpgcheck=0

[epel-repo]
name=epel-repo
baseurl=http://172.28.128.1/repo/Centos-6.5-epel/
gpgcheck=0

[puppet-repo]
name=puppet-repo
baseurl=http://172.28.128.1/repo/product/
gpgcheck=0

[puppet-deps]
name=puppet-deps
baseurl=http://172.28.128.1/repo/puppet-deps/
gpgcheck=0 " > /etc/yum.repos.d/server.repo
yum install puppet puppet-server -y && service puppetmaster start && service puppet start
