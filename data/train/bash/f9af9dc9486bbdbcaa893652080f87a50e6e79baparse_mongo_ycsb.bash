#!/bin/bash

fullPath=$1
dirName=$2

machineName=`echo ${dirName} | cut -d "-" -f1`
numRecords=`echo ${dirName} | cut -d "-" -f6`
benchId=`echo ${dirName} | cut -d "-" -f7`
mongoType=`echo ${dirName} | cut -d "-" -f5`

#    raw_line=`grep ${search_string} /tmp/tmcinfo.txt`
#    this_what=`echo ${raw_line} | cut -d " " -f4`

echo "---------------------------------------------------------"
echo "type = ${machineName}, ${benchId}, ${numRecords}"

for i in ${fullPath}/*ycsbLoad*.log; do
  loadSize=`grep "post-load" ${i} | cut -d " " -f15`
  loadSpeed=`grep "Throughput(ops/sec)" ${i} | cut -d "," -f3`
  loadSpeedNice=`echo "scale=1; ${loadSpeed}/1" | bc `  
done

echo "---------------------------------------------------------"
echo "threads/avg/exit : load / ${loadSpeedNice} / ${loadSize}"

#for i in ${fullPath}/*${benchName}*.log; do
#  baseName=$(basename $i)
#  threadCount=`echo ${baseName} | cut -d "-" -f5`
#  runSize=`grep "post-load" ${i} | cut -d " " -f15`
#  runSpeed=`tail -n1 ${i}.tsv | cut -f2`
#  echo "threads/avg/exit : ${threadCount} / ${runSpeed} / ${runSize}"
#done
