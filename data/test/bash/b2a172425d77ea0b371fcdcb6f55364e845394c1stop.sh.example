#!/bin/bash

ROOT_DIR=$(pwd)

PROCESSES_DIR=$ROOT_DIR/processes

CONFIG_DIR=$ROOT_DIR/config

LOG_DIR=$ROOT_DIR/log


PROCESS_EXIST=0
PROCESS_NOT_EXIST=1


PROCESS_LIST=("gateway" "world" "func" "session" "router" "dbcached")

function killProcess()
{
	sleep 1
	RESULT=$(ps -x |grep _exec |grep server |awk '{print $5 $6}' |grep "$1")
	if [[ "$RESULT" == "" ]]
	then
		return $PROCESS_NOT_EXIST
	else
		killall $1"_exec"
		return $PROCESS_EXIST
	fi
}

for ((i=0; i<${#PROCESS_LIST[*]}; )); do
	PROCESS=${PROCESS_LIST[$i]}
	echo "stop $PROCESS"_exec" ......"
	killProcess $PROCESS
	if [[ $? -eq $PROCESS_NOT_EXIST ]]
	then
		echo "$PROCESS"_exec" stop sucess!"
		i=$(($i+1))
	else
		continue
	fi
done

