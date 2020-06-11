#!/bin/bash

ROOT_DIR=$(pwd)

PROCESSES_DIR=$ROOT_DIR/processes

CONFIG_DIR=$ROOT_DIR/config

LOG_DIR=$ROOT_DIR/log

PROCESS_EXIST=0
PROCESS_NOT_EXIST=1

ulimit -c unlimited


PROCESS_LIST=("router 1" "world 1" "gateway 1")
#PROCESS_LIST=("router 1" "dbcached 1" "session 1" "func 1" "world 1" "world 2" "gateway 1")

function checkProcessExist()
{
	RESULT=$(ps -x |grep _exec |grep server |awk '{print $5 $6}' |grep "$1" |grep "$2")
	if [ "$RESULT" == "" ]
	then
		return $PROCESS_NOT_EXIST
	else
		return $PROCESS_EXIST
	fi
}

for ((i=0; i<${#PROCESS_LIST[*]}; i++)); do
	PROCESS=${PROCESS_LIST[$i]}
	NAME=$(awk -v process="$PROCESS" 'BEGIN{print process}' |awk '{print $1}')
	NUM=$(awk -v process="$PROCESS" 'BEGIN{print process}' |awk '{print $2}')
	checkProcessExist $NAME $NUM
	if [[ $? -eq "$PROCESS_NOT_EXIST" ]]
	then
		$PROCESSES_DIR/$NAME/$NAME"_exec" $NUM $CONFIG_DIR $LOG_DIR || exit 1 &
	else
		echo "process $NAME-$NUM exist!"
	fi
done

ps -x |grep _exec |grep server
