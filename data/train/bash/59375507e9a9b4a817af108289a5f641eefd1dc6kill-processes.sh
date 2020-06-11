#!/bin/bash
##############################################################
# This script kills all processes that are related to the passed `process name` 
# runit will start them up again with the new configuration
#
# Argument 1: Part of process name, or string that should be present in the process names
##############################################################
process_name=$1

if [ -z "$process_name" ];
then
    echo "Usage: $(basename $0) <process name> (String that must be included in the process names)"
    exit 1;
fi

pids=$(ps | grep "$process_name" | grep -v "grep" | awk '{print $1}');
echo "Killing $process_name processess with Process IDs: ${pids}"
kill -KILL ${pids}