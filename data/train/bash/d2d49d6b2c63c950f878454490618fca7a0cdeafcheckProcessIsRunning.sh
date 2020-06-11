#!/bin/sh
# ---------------------------------------------------------------------------------------------------------------------------------------
# Script to check if a given process is running or not
# Parameter: $1 - PID of process
# Returns 1 if the process is running and
# Returns 0 if the process is NOT RUNNING
# ---------------------------------------------------------------------------------------------------------------------------------------
if [[ $1 != "" && -d "/proc/$1" ]]; then
   exit 1
else
   exit 0
fi
