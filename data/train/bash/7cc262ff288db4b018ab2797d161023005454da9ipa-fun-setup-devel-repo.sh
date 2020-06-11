#!/bin/bash

##############################################################################
# Author: Tomas Babej <tbabej@redhat.com>
#
# Sets up the devel repo. Makes it disabled by default.
#
# Usage: $0
# Returns: 0 on success, 1 on failure
##############################################################################

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh

set -e

# Sets correct repository for the platform used
case $PLATFORM in
  fc) REPO_NAME="ipa-devel-fedora.repo";;
  el) REPO_NAME="ipa-devel-rhel.repo" ;;
esac

# Configure devel repo
if [ ! -f /etc/yum.repos.d/$REPO_NAME ]
then
    if [ ! -f  ~/$REPO_NAME ]
    then
        pushd ~ >/dev/null
        wget http://jdennis.fedorapeople.org/ipa-devel/$REPO_NAME
    fi
    sudo cp ~/$REPO_NAME /etc/yum.repos.d/
    echo "Configuring $PLATFORM_NAME devel repo."
else
    echo "$PLATFORM_NAME devel repo is already configured."
fi

# Make sure the repo is disabled by default
sudo sed -i "s/enabled=1/enabled=0/g" /etc/yum.repos.d/$REPO_NAME
