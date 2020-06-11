#!/bin/bash

#**********************************************************************************************************************
# red5     This shell script takes care of starting and stopping red5
#
# chkconfig: 2345 85 85
#
### BEGIN INIT INFO
# Provides:          red5
# Required-Start:    $network $syslog
# Required-Stop:     $network $syslog
# Default-Start:
# Default-Stop:
# Short-Description: Start red5 daemon at boot time
# Description:       start, stop and restart red5.
### END INIT INFO
#
# Created By: Arul - me@arulraj.net
# Update history:
# v0.1 - 30-Aug-2014 - First release
#**********************************************************************************************************************

# Give your red5 installed path here
export RED5_HOME=/usr/share/red5
PROCESS_ID=0
PROG="red5"
PIDFILE=/var/run/$PROG.pid

# Returns 0 if the process with PID $1 is running.
function checkProcessIsRunning {
    local PROCESS_ID="$1"
    if [ -z "$PROCESS_ID" -o "$PROCESS_ID" == "" ]; then
        return 1;
    fi
    if [ ! -e /proc/$PROCESS_ID ]; then
        return 1;
    fi
    return 0;
}

# Returns 0 if the process with PID $1 is our Java service process.
function checkProcessIsOurService {
    local PROCESS_ID="$1"
    if [ "$(ps-p$PROCESS_ID--no-headers-ocomm)" != "java" ]; then
        return 1;
    fi
    grep -q --binary -F "$PROG" /proc/$PROCESS_ID/cmdline
    if [ $? -ne 0 ]; then
        return 1;
    fi
    return 0;
}

# Returns 0 when the service is running and sets the variable $PROCESS_ID to the PID.
function getServicePID {
    if [ ! -f $PIDFILE ]; then
        return 1;
    fi
    PROCESS_ID="$(<$PIDFILE)"
    checkProcessIsRunning $PROCESS_ID || return 1
    checkProcessIsOurService $PROCESS_ID || return 1
    return 0;
}

function start() {
    echo $"Starting $PROG..."
    getServicePID
    if [ $? -eq 0 ]; then
        echo "$PROG is already running in PID=$PROCESS_ID";
        RETVAL=0;
        return 0;
    fi
    $RED5_HOME/red5.sh 1 > $RED5_HOME/log/stdout.log 2 > $RED5_HOME/log/stderr.log &
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo $! > $PIDFILE
        touch /var/lock/subsys/$PROG
        PROCESS_ID="$(<$PIDFILE)"
    fi
    sleep 0.1
    checkProcessIsRunning $PROCESS_ID
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "started PID="$PROCESS_ID
    else
        echo "$PROG start failed, see logfile."
    fi
    return $RETVAL
}

function stop() {
    getServicePID
    if [ $? -ne 0 ]; then
        echo "$PROG is not running";
        RETVAL=0;
        echo "";
        return 0;
    fi
    echo $"Stopping $PROG..."
    $RED5_HOME/red5-shutdown.sh
    RETVAL=$?
    sleep 0.1
    checkProcessIsRunning $PROCESS_ID
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        rm -f /var/lock/subsys/$PROG
        echo "stopped PID=$PROCESS_ID"
    else
        echo "$PROG stop failed, see logfile."
    fi
    return $RETVAL
}

function restart() {
    stop
    sleep 0.1
    start
}

function status() {
    echo -n "Checking for $PROG:"
    if getServicePID; then
        echo "running PID=$PROCESS_ID"
        RETVAL=0
    else
        echo "stopped"
        RETVAL=3
    fi
    return 0;
}

# How its called.
function main {
    RETVAL=0
    case "$1" in
        start)
            start
        ;;
        stop)
            stop
        ;;
        status)
            status
        ;;
        restart)
            restart
        ;;
        *)
            echo $"Usage: $0 {start|stop|status|restart}"
            exit 1
        ;;
    esac
    exit $RETVAL
}