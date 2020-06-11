#!/bin/bash

# STANDARD_RIFT_IO_COPYRIGHT


ppid=$PPID

echo "Parent process $ppid monitor wrapping: $@"
"$@"&
pid=$!

# Kill the child process when this monitor process exits
trap "echo Terminating child process: $pid; kill -s SIGTERM $pid" EXIT

# Exit when we detect the parent process has exited
while true; do
  kill -0 $ppid 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Parent process exited. Exiting."
    exit 0
  fi

  kill -0 $pid 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Child process died. Exiting."
    exit 1
  fi

  sleep .5
done
