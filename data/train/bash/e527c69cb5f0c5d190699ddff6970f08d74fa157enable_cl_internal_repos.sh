#!/bin/bash
# -*- mode:sh; coding:utf-8; -*-
# author: Eugene Zamriy <eugene@zamriy.info>
# created: 2016-04-27
# description: Enables CloudLinux internal repositories.


REPO_FILE='/etc/yum.repos.d/cloudlinux.repo'
DUMP_FILE='/root/cloudlinux.repo.backup'

cp -a ${REPO_FILE} ${DUMP_FILE}

sed -i -e '/\[cloudlinux-base\]/,/^\[/s/enabled=0/enabled=1/' ${REPO_FILE}
sed -i -e '/\[cloudlinux-base\]/,/^\[/s/mirrorlist=/# mirrorlist=/' ${REPO_FILE}
sed -i -e '/\[cloudlinux-base\]/,/^\[/s/# baseurl=http:\/\/repo/baseurl=http:\/\/koji/' ${REPO_FILE}
sed -i -e '/\[cloudlinux-updates\]/,/^\[/s/enabled=0/enabled=1/' ${REPO_FILE}
sed -i -e '/\[cloudlinux-updates\]/,/^\[/s/mirrorlist=/# mirrorlist=/' ${REPO_FILE}
sed -i -e '/\[cloudlinux-updates\]/abaseurl=http:\/\/koji\.cloudlinux\.com\/cloudlinux\/\$releasever\/updates\/\$basearch\/' ${REPO_FILE}
