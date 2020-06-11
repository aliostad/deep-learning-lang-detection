#!/bin/bash

function StartProcessFromCg()
{
    [ $# -ne 3 ] && "echo "usage:";exit 1"
    
    local CGROUP="$1"
    local COMMAND="$2"
    local ARGS="$3"
    local PROCESS="${COMMAND} ${ARGS}"
    local PROCESS_PPID=0
    local PROCESS_PID=0
    local EXEC_PROCESS=""

    # Check for the test cgroup.
    if [ -f ${CGROUP} ]
    then
        sh -c "echo \$$ >> ${CGROUP}/tasks && ${PROCESS}" & 
    else
        echo "ERROR: The '${CGROUP}/tasks' file cannot find."
        return 1
    fi

    EXEC_PROCESS='sh -c echo $$ >> '"${CGROUP}/task && ${PROCESS}"
    
    # Get the ppids of the write processes.
    PROCESS_PPID=`ps -f --ppid $$  | awk '{if($8=="sh") {$8="#=#=#sh";print $0}}' | awk -vcgroup="$CGROUP" -vexec_process="$EXEC_PROCESS" -F '#=#=#'  '{if ($2==exec_process) {print $1}}' | tail -1 | awk '{print $2}'`
    PROCESS_PPID=$((PROCESS_PPID+1))

    # Get the pid of the write processes by their ppids.
    PROCESS_PID=`ps --ppid ${PROCESS_PPID} | tail -1 | awk '{print $1}'`
    trap "kill -9 ${PROCESS_PPID} >/dev/null 2>&1" EXIT
}
