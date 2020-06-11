#!/bin/bash
# author: jianingy.yang@gmail.com

mountpoint=~/devel/devstack

case "$1" in
  -u) shift; umount=1 ;;
esac

if ! ping &>/dev/null -n -c2 devstack; then
  echo "devstack server not started"
  exit 1
fi

if grep -q 'devstack:/opt/stack' /etc/mtab; then
  echo "devstack already mounted"
  if [ -n "$umount" ]; then
    invoke-sudo.sh -v umount $mountpoint
  fi
  exit 2
fi
echo Mouting /opt/stack to ~/devel/devstack
invoke-sudo.sh -v mount -t nfs -o soft,intr,rsize=32768,wsize=32768 devstack:/opt/stack $mountpoint
