#!/bin/bash

REPO=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'git-repo:' | sed -e 's/git-repo: //'`
TARBALL=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'tarball-repo:' | sed -e 's/tarball-repo: //'`

if [ -n "$REPO" ]; then
	if [ -d /home/ec2-user/user-repo ]; then
		cd /home/ec2-user/user-repo
		/usr/bin/git pull 
	else
		/usr/bin/git clone $REPO /home/ec2-user/user-repo
	fi
else
	rm -rf /home/ec2-user/user-repo
	mkdir /home/ec2-user/user-repo
	cd /home/ec2-user/user-repo
	curl -s $TARBALL | tar -xz
fi
