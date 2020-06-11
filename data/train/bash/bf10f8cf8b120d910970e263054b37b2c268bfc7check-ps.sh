#!/bin/bash

process_list=""
failed_process_list=""
total_failed_process=0
error=0

for i in `cat /etc/sensu/plugins/process_list`
do
 numberofprocess=`ps aux |grep $i|grep -v grep |grep -v check-process |wc -l`
 if [ $numberofprocess -ne 0 ]; then
   process_list+=$i", "
 else
   failed_process_list+=$i", "
   total_failed_process+=1
 fi
done

if [ $total_failed_process -eq 0 ]; then
  if [ -z "$process_list" ]; then
    echo "OK - NO PROCESSES CONFIGURED FOR CHECK"
    exit 0
  fi
  echo "OK - All required processes are running -" $process_list
  exit 0
else
  echo "CRITICAL - Some required processes are not running -" $failed_process_list
  exit 2
fi
