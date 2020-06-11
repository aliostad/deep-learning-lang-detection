#!/usr/bin/env bash
set -e
OS=$1
COLLECTION=$2

if [ $COLLECTION ]
then
  REPO_NAME="puppetlabs-release-"$COLLECTION"-"$OS
else
  REPO_NAME="puppetlabs-release-"$OS
fi

if [ -e "/etc/debian_version" ]
then
  if [ $COLLECTION ]
  then
    repo_file="/etc/apt/sources.list.d/puppetlabs-$COLLECTION.list"
  else
    repo_file="/etc/apt/sources.list.d/puppetlabs.list"
  fi
  if [ -e $repo_file ]
  then
    # collection repo already installed
    echo "colection repo already installed..."
  else
    # download puppet collection repo
    echo "installing colection repo"
    wget http://apt.puppetlabs.com/$REPO_NAME.deb
    # install puppet collection repo
    dpkg -i $REPO_NAME.deb
  fi
  # Update apt
  echo "Update APT..."
  DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update >/dev/null
else
  if [ $COLLECTION ]
  then
    repo_file="/etc/yum.repos.d/puppetlabs-$COLLECTION.repo"
  else
    repo_file="/etc/yum.repos.d/puppetlabs.repo"
  fi
  if [ -e $repo_file ]
  then
    # collection repo already installed
    echo "colection repo already installed..."
  else
    # import gpg keys
    echo "importing gpg keys"
    rpm --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
    echo "installing colection repo"
    # install puppet collection repo
    yum localinstall -y http://yum.puppetlabs.com/$REPO_NAME.noarch.rpm
  fi
fi
