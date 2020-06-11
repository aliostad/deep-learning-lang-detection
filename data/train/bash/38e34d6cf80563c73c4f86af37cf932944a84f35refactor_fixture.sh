#!/usr/bin/env bash
echo $0
echo $1
echo $2
echo $3
echo $4

echo 'These are the files that will be refactored...'
ls -al "$1--$2--"*.json
echo 'Nullifying all PKs...'
sed -e 's/^\ \"pk\"\:\ \".*\"\,/"pk": null,/g' --in-place='' "$1--$2--"*.json
echo 'Changing the model name from '"$1"."$2"' to '"$3"."$4"' using: sed -e ' 's/^\ \"model\"\:\ \"'$1'\.'$2'\"\,/\ \"model\"\:\ "'$3'\.'$4'\"\,/g'
sed -e 's/^\ \"model\"\:\ \"'$1'\.'$2'\"\,/\ \"model\"\:\ "'$3'\.'$4'\"\,/g' --in-place='' $1--$2--*.json
# echo 'Renaming the files...' 's/^\ \"model\"\:\ \"'$1'\.'$2'\"\,/\ \"model\"\:\ "'$3'\.'$4'\"\,/g'
# 
