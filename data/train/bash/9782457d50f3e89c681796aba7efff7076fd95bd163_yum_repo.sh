#!/bin/bash

#########################################
# This script will install REPO
#########################################

# REPO Defaults
REPO_URL="http://mirrors.163.com/.help/CentOS6-Base-163.repo"
REPO_NAME="CentOS6-Base-163.repo"
REPO_DEFAULT_DIR="/etc/yum.repos.d"


# Download and unpack Nginx
wget -q $REDIS_URL

mv $REPO_DEFAULT_DIR/CentOS-Base.repo  $REPO_DEFAULT_DIR/CentOS-Base.repo_bak

# Move into the directory  and yum update
mv $REPO_NAME   $REPO_DEFAULT_DIR/
yum clean all
yum makecache
yum update

