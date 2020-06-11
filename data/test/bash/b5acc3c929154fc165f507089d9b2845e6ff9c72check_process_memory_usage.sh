#!/bin/bash

# Author: Imran Ahmed <researcher6@live.com>
# Purpose : Monitors memory utilization by individual processes and terminates a process that exceeds the limit.

# Variables

#log_file="/var/log/Memory.log"
max_allowed_mem=460800
process_list=( "rbtserver1" "rbtserver2" "rbtserver3" )

echo -n `date` 
echo "    Checking processes for memory usage."

for process in "${process_list[@]}"
do
	pid=$(/sbin/pidof $process)
	echo -n `date`
	echo -n  " Process : $process ," 
	echo -n  " PID : $pid ," 
	if [ ${#pid} -gt 0 ]; then
		process_mem=$(ps -o rss -p $pid | sort -k 1 -nr|head -1)
	echo -n " Memory used : $process_mem ,"
	echo " Maximum Threshold : $max_allowed_mem"
		if [ $process_mem -gt $max_allowed_mem ]; then
			echo -n `date`
			echo "  CRITICAL! Process: $process exceeds allowed memory threshold  $max_allowed_mem. Current memory used is $process_mem. Terminating ..." 
			kill -9 $pid
		fi
	fi
done

echo ""

