#!/bin/bash



NETSTAT=`which netstat`
PROCESS_DETAILS="tomcat"
PROTO="tcp"
LOCAL_IP=`/sbin/ip addr show dev eth0 | grep "inet "| awk '{print $2}'  | awk -F"/" '{ print $1 }'`
LOCAL_PORT="8080"

N=`basename $0`
PROCESS_ID=`ps -auxfw 2>/dev/null | grep ${PROCESS_DETAILS} | grep -v "grep" | grep -v ${N}| awk '{ print $2}' `


if [ ${PROCESS_ID} -eq ${PROCESS_ID} 2>/dev/null ];
then
    echo ${PROCESS_ID}" is a number" >/dev/null
    CONN_COUNTER=`/usr/bin/sudo ${NETSTAT} -ntpla | grep "ESTABLISHED "${PROCESS_ID}"/" | grep ${LOCAL_IP}":"${LOCAL_PORT} | grep ${PROTO} | wc -l`
#    echo "OK "${NETSTAT}" "${LOCAL_IP}" "$LOCAL_PORT"  "${PROCESS_DETAILS}" has "${CONN_COUNTER}" established (${PROCESS_ID})"${PROTO}" connections | "${PROCESS_DETAILS}"_connections="${CONN_COUNTER}
    echo "OK - "${PROCESS_DETAILS}" has "${CONN_COUNTER}" established "${PROTO}" connections | "${PROCESS_DETAILS}"_connections="${CONN_COUNTER}
    else
        echo "PID Should be integer. no such process?"
        exit 3
fi
