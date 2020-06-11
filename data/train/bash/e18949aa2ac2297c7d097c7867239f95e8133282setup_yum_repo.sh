#!/bin/bash

if [ -z "${YUM_REPO_BUCKET:-}" ]; then
    echo "No yum repo bucket was specified - skipping this script"
    exit 0
fi

yum clean all
yum makecache

yum install -y s3yum-plugin

(
    cd /opt/s3yum-plugin/

    ## setup the s3iam.repo
    cp s3iam.repo /etc/yum.repos.d/$YUM_REPO_BUCKET.repo
    perl -i -pe "s{\[s3iam\]}{\[$YUM_REPO_BUCKET\]}g" /etc/yum.repos.d/$YUM_REPO_BUCKET.repo
    perl -i -pe "s{name=.*}{name=$YUM_REPO_BUCKET}g" /etc/yum.repos.d/$YUM_REPO_BUCKET.repo
    perl -i -pe "s{baseurl=.*}{baseurl=https://$YUM_REPO_BUCKET.s3.amazonaws.com/repo}g" /etc/yum.repos.d/$YUM_REPO_BUCKET.repo

    ## setup the plugin
    mkdir -p /etc/yum/pluginconf.d/
    cp s3iam.conf /etc/yum/pluginconf.d/

    ## setup the actual plugin
    mkdir -p /usr/lib/yum-plugins/
    cp s3iam.py /usr/lib/yum-plugins/
    yum clean all
    yum makecache
)
