# SLD ( System Logging Daemon )
# 1. Process Logging
# 2. Whois logging
# 3. Network Status


#!/bin/bash


#init directory ./logs - if ./logs not exist mkdir ./logs
if [ ! -d "./logs" ]
then
         mkdir "./logs"
fi

#Process Checker
declare -a processers=("php" "mysql" "nginx")
for process in "${processers[@]}" 
do
	now="$(date +'%Y-%m-%d-%H-%M')"
	time_path="$(date +'%Y%m%d')"
	FILENAME="$process-$now.state"
	PROCESS_DIR="./logs/$process";
	if [ ! -d $PROCESS_DIR ];
	then
        	mkdir $PROCESS_DIR
	fi

	FULL_DIR="./logs/$process/$time_path";

        if [ ! -d $FULL_DIR ];
        then
                mkdir $FULL_DIR
        fi

	ps -aux | grep $process >> $FULL_DIR/$FILENAME
done
