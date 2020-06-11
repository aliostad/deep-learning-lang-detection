#!/bin/bash

VERSION=v`date +%Y.%j`
DESC=$@

if [ -z "$DESC" ] ; then
    echo "Description required"
elif [ ! -d .repo ] ; then
    echo "No .repo directory"
else
    repo forall -c git tag -a $VERSION -m "$DESC"
    repo forall -c git push --tags
    repo manifest -r -o default.xml.tmp
    mv default.xml.tmp .repo/manifests/default.xml
    pushd .
    cd .repo/manifests
    git checkout -b $VERSION
    git commit -a -m "$DESC"
    git push -u origin $VERSION
    git checkout default
    git branch -D $VERSION
    popd
fi
