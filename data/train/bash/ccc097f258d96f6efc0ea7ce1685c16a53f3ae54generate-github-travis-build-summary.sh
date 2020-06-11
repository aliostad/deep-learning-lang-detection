#!/bin/bash

# we need at least two args: gihub user/organization AND at least one repo name
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "usage: $0 [github user/organization] repo0 repo1 repo2 ... repoN"
    exit 1;
fi

GITHUB_USER_ORG=$1

# args 2, 3, 4 ... N are repo names, so skip arg1 required/positional args to adjust $@
shift 1
GITHUB_REPOS="$@"

temp=`basename $0`
SUMMARY=`mktemp /tmp/${temp}.XXXXXX` || exit 1

# create .md table header
echo "|repo|travis build status|" >> $SUMMARY
echo "|:---|:------------------|" >> $SUMMARY

for repo in $GITHUB_REPOS
do
    # use curl to check if the repo does have a .travis.yml file
    http_status=`curl -s -o /dev/null -w "%{http_code}" https://raw.githubusercontent.com/$GITHUB_USER_ORG/$repo/master/.travis.yml`

    if [ "$http_status" -ne "200" ]
    then
	echo "|[$repo](https://github.com/$GITHUB_USER_ORG/$repo)|N/A|" >> $SUMMARY

    else
	echo "|[$repo](https://github.com/$GITHUB_USER_ORG/$repo)|[![Build Status](https://travis-ci.org/$GITHUB_USER_ORG/$repo.svg?branch=master)](https://travis-ci.org/$GITHUB_USER_ORG/$repo)|" >> $SUMMARY

    fi
done

cat $SUMMARY
