#!/bin/bash -x
#take care of some prerequirements

THISFILE=$(basename "${0}")
THISDIR=${0%$THISFILE}
BASEDIR=${0%os/$THISFILE}

[ $REPOFILE ] || . $BASEDIR/os/repo.env

if [ ! $1 ]; then
  #setup local yum repo
  [ -f /etc/yum.repos.d/public-yum-ol6.repo ] && ( mv /etc/yum.repos.d/public-yum-ol6.repo{,.ori} ; touch /etc/yum.repos.d/public-yum-ol6.repo )
  [ -f /etc/yum.repos.d/local.repo ] && echo "local.repo found, skipping the download"
  if [ ! -f /etc/yum.repos.d/local.repo ]; then
    [[ $REPO =~ http* ]] && curl -o /etc/yum.repos.d/local.repo $REPOFILE || \cp $REPOFILE /etc/yum.repos.d/local.repo
  fi
  yum clean all
else
  [ -f /etc/yum.repos.d/local.repo ] && \rm /etc/yum.repos.d/local.repo
  [ -f /etc/yum.repos.d/public-yum-ol6.repo.ori ] && \mv /etc/yum.repos.d/public-yum-ol6.repo{.ori,}
fi

