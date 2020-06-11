#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装wget下载工具
yum  install  -y  wget

#备份原有的yum文件
#备注：阿里云主机的yum文件只有一个CentOS-Base.repo，且已经使用的mirrors.aliyun.com的源

#mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
#mv /etc/yum.repos.d/CentOS-Debuginfo.repo /etc/yum.repos.d/CentOS-Debuginfo.repo.backup
#mv /etc/yum.repos.d/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo.backup
#mv /etc/yum.repos.d/CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo.backup
#mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
#mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup

#检测系统的版本，根据不同的版本执行不同的命令
releasever=`cat  /etc/issue  |  grep  -iw  "CENTOS"  |  awk  '{print  $3}' |  awk  -F  '.'   '{print  $1}'`

if  [ $releasever == 5 ]
then
	#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo

#如果是阿里云主机需要替换aliyun为aliyuncs，节省外网流量并加快下载速度
#sed  -i  's/aliyun/aliyuncs/g'   /etc/yum.repos.d/CentOS-Base.repo
#sed  -i  's/aliyun/aliyuncs/g'   /etc/yum.repos.d/epel.repo
else
	if  [ $releasever == 6 ]
	then
		#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
		wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

#如果是阿里云主机替换aliyun为aliyuncs，节省外网流量并加快下载速度
#		sed  -i 's/aliyun/aliyuncs/g'   /etc/yum.repos.d/CentOS-Base.repo
#		sed  -i 's/aliyun/aliyuncs/g'   /etc/yum.repos.d/epel.repo
	else
		exit 1
	fi
fi

#创建yum缓存
yum repolist

#判断该脚本的执行返回结果，如果不正常则不在执行之后的安装脚本