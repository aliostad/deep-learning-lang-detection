#!/bin/bash
echo "=====start check yum ENV====="
if [ -d "/etc/yum.repos.d" ];then

	echo "=====rename old repo file====="
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup 
	echo "=====start download repo file from aliyun====="
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo 

	echo "=====add nginx.reop file====="
	cp conf/nginx.repo /etc/yum.repos.d/nginx.repo

	echo "=====makecache====="
	yum makecache

	echo "done....."	
else
	echo 'yum.repos.d no exist'
fi





