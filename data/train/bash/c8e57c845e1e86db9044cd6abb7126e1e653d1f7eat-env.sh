#!/bin/bash
# A script to get DISPLAY and DBUS related environment variables from a running 
# process to the shell session

# A running process to get the DBUS settings from
PROCESS=mcompositor
PROCESS_ID=`pgrep $PROCESS`

if [ -n "$PROCESS_ID" ]; then
$(cat /proc/$PROCESS_ID/environ | tr '\000' '\n'\
	| egrep 'DBUS|DISPLAY' | sed 's/^/export\ /')
else
echo "eat-env.sh: Got no PID for command: $PROCESS"
echo "eat-env.sh: Environment variable setup failed"
fi

if [ $(id -u) -eq 0 ]; then
    su meego -c "xhost +"
fi
