#!/bin/bash

# start a process and check that it is started
# usage: start_process.sh <path_to_executable> [<arguments>] -dir <start_command_dir> [-checkAfter <process_start_time>] [-title <title>]

WORKINGDIR="."
PROCESS_START_TIME=0
TITLE=""

if [ $# -lt 1 ]; then
 echo "Usage: start_process.sh <path_to_executable> [<arguments>] -dir <start_command_dir> [-title <title>] [-checkAfter <process_start_time>] "
 exit
fi

EXECUTABLE=$1
if [ "$2" != "-dir" ] && [ "$2" != "-checkAfter" ] && [ "$2" != "-title" ] ; then
    ARGS=$2
    shift
fi

if [ "$2" == "-dir" ] ; then
    WORKINGDIR=$3
    shift 2
fi
if [ "$2" == "-title" ] ; then
    TITLE=$3
    shift 2
fi
if [ "$2" == "-checkAfter" ] ; then
    PROCESS_START_TIME=$3
    shift 2
fi

echo "Executable: $EXECUTABLE"
echo "ARGS: $ARGS"
echo "WORKINGDIR: $WORKINGDIR"
echo "TITLE: $TITLE"
echo "PROCESS_START_TIME: $PROCESS_START_TIME"

cd $WORKINGDIR
nohup $EXECUTABLE $ARGS $2 &>/dev/null &

PID=$!

sleep $PROCESS_START_TIME

ps -p $PID >/dev/null || (echo "Process is not started"; exit -1)
