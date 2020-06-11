#!/bin/bash

set +vx
service ntpd start
chkconfig ntpd on

project_root="/app/hadoop-data-pipeline-generic"

echo "Changing Process File"
cd ${project_root}/falcon/process
cp processData.xml processData.xml.ORIGINAL

vl=`grep -n "validity" processData.xml.ORIGINAL | awk -F':' '{ print $1 }'`
tl=`wc -l processData.xml.ORIGINAL | awk '{ print $1 }'`
vlb=$(( $vl - 1 ))
vla=$(( $vl + 1 ))

ve=$(date -d "+10 days" +"%Y-%m-%dT%H:%MZ")
vs=$(date -d "+1 minutes" +"%Y-%m-%dT%H:%MZ")

head -n $vlb processData.xml.ORIGINAL  >> processData.xml.new
echo "<validity start=\"${vs}\" end=\"${ve}\" />" >> processData.xml.new
tail -n +$vla  processData.xml.ORIGINAL >> processData.xml.new

rm processData.xml
mv processData.xml.new processData.xml
cd - 