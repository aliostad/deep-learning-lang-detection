#!/bin/bash
#1. epel
#rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
rpm -Uvh http://mirror.premi.st/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install yum-plugin-protectbase.noarch -y

#2. erlang
#wget -O /etc/yum.repos.d/epel-erlang.repo http://repos.fedorapeople.org/repos/peter/erlang/epel-erlang.repo
#http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_3_general/esl-erlang_18.0-1~centos~6_amd64.rpm

#vi /etc/yum.repos.d/epel-erlang.repo
# Place this file in your /etc/yum.repos.d/ directory

repo="/etc/yum.repos.d/epel-erlang.repo"
echo "[epel-erlang]" > $repo
echo "name=Erlang/OTP R14B" >> $repo
echo "#baseurl=http://mirror.premi.st/epel/6/x86_64/erlang-\$releasever" >> $repo
echo "baseurl=http://mirror.premi.st/epel/6/x86_64" >> $repo
echo "enabled=1" >> $repo
echo "skip_if_unavailable=1" >> $repo
echo "gpgcheck=0" >> $repo
echo " " >> $repo
echo "[epel-erlang-source]" >> $repo
echo "name=Erlang/OTP R14B - Source" >> $repo
echo "baseurl=http://mirror.premi.st/epel/6/x86_64/erlang-\$releasever" >> $repo
echo "enabled=0" >> $repo
echo "skip_if_unavailable=1" >> $repo
echo "gpgcheck=0" >> $repo


yum install erlang -y


#3. rabbitmq
#wget http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.5/rabbitmq-server-2.8.5-1.noarch.rpm
#wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.4/rabbitmq-server-3.5.4-1.noarch.rpm
#rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
#yum install rabbitmq-server-3.5.4-1.noarch.rpm

"vi /etc/yum.repos.d/epel-rabbitmq.repo"
# Place this file in your /etc/yum.repos.d/ directory

repo="/etc/yum.repos.d/epel-rabbitmq.repo"
echo "[epel-rabbitmq]" > $repo
echo "name=rabbitmq-server" >> $repo
echo "baseurl=http://mirror.premi.st/epel/6/x86_64" >> $repo
echo "enabled=1" >> $repo
echo "skip_if_unavailable=1" >> $repo
echo "gpgcheck=0" >> $repo
echo " " >> $repo
echo "[epel-rabbitmq-source]" >> $repo
echo "name=rabbitmq - Source" >> $repo
echo "baseurl=http://mirror.premi.st/epel/6/x86_64/erlang-\$releasever" >> $repo
echo "enabled=0" >> $repo
echo "skip_if_unavailable=1" >> $repo
echo "gpgcheck=0" >> $repo

yum install rabbitmq-server -y
