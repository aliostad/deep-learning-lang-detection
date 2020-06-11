#!/bin/sh
#
# ******************************************************************************
# Software:     CentOSGeoWebEnv
# Author:       mapdb
# Website:      www.mapdb.cn
# Email:        mapdb2014@gmail.com
# ------------------------------------++++
# Thank you for choosing CentOSGeoWebEnv!
# ******************************************************************************
#

if [ -e "./mongodb.repo" ]; then
    cp ./mongodb.repo /etc/yum.repos.d/mongodb.repo
elif [ -e "./soft/mongodb.repo" ]; then
    cp ./soft/mongodb.repo /etc/yum.repos.d/mongodb.repo
fi

yum install -y mongodb-org
