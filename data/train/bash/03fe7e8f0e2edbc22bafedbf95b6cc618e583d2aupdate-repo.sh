#!/bin/bash

SOURCE=/vagrant/output
REPO=/vagrant/repo

# install packaging tools
sudo apt-get update
sudo apt-get install -y dpkg-dev

mkdir -p ${REPO}
mkdir -p ${REPO}/source
mkdir -p ${REPO}/binary-amd64
mkdir -p ${REPO}/binary-i386

# add packages to tree
cd ${SOURCE}

# source files
mv *.dsc ${REPO}/source
mv *.gz ${REPO}/source

# 64 bit files
FILES=$(find . -regex ".*\amd64.*")
for f in $FILES
do
	mv $f ${REPO}/binary-amd64
done

# 32 bit files
FILES=$(find . -regex ".*\i386.*")
for f in $FILES
do
	mv $f ${REPO}/binary-i386
done

# create summary files 
cd ${REPO}
dpkg-scanpackages binary-amd64 /dev/null | gzip -9c > binary-amd64/Packages.gz
dpkg-scanpackages binary-i386 /dev/null | gzip -9c > binary-i386/Packages.gz
dpkg-scansources source /dev/null | gzip -9c > source/Sources.gz

cd ..
touch ${REPO}/Release

# add the following lines to your /etc/apt/sources.list
#   deb http://archive.quikdeploy.com/ubuntu precise 
#   deb-src http://archive.quikdeploy.com/ubuntu precise
