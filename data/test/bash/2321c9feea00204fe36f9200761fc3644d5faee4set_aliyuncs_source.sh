#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装wget下载工具
yum  install  -y  wget

#备份原有的yum文件
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
mv /etc/yum.repos.d/CentOS-Debuginfo.repo /etc/yum.repos.d/CentOS-Debuginfo.repo.backup
mv /etc/yum.repos.d/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo.backup
mv /etc/yum.repos.d/CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo.backup
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup

#检测系统的版本，根据不同的版本执行不同的命令
releasever=`cat  /etc/issue  |  grep  -iw  "CENTOS"  |  awk  '{print  $3}' |  awk  -F  '.'   '{print  $1}'`

if  [ $releasever == 5 ]
then
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo

#替换aliyun为aliyuncs
sed  -i  's/aliyun/aliyuncs/g'   /etc/yum.repos.d/CentOS-Base.repo
sed  -i  's/aliyun/aliyuncs/g'   /etc/yum.repos.d/epel.repo
else
	if  [ $releasever == 6 ]
	then
		wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
		wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

#替换aliyun为aliyuncs
		sed  -i 's/aliyun/aliyuncs/g'   /etc/yum.repos.d/CentOS-Base.repo
		sed  -i 's/aliyun/aliyuncs/g'   /etc/yum.repos.d/epel.repo
	else
		exit 1
	fi
fi

#创建yum缓存
yum makecache

