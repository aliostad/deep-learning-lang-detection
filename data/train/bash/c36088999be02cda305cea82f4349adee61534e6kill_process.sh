#!/bin/sh

set -e
#set -x

if [ $# -gt 1 ]; then
        echo "usage: $(basename $0) PROCESS_NAME(MB)" >& 2
        echo "example: $(basename $0) 'iperf -s -u'"
        exit 1
fi

#kill all process for next test
IPERF_PROCESS_ID=`ps -aux | grep "$1" | grep -v "grep" | awk '{print $2}'`

if [ ! -z "$IPERF_PROCESS_ID" -a "$IPERF_PROCESS_ID" != " " ]; then
        
	for i in $(echo $IPERF_PROCESS_ID | tr " " "\n")
	do
	    echo "$i"	
	    if ! kill -13 $i;then
	  	    echo "can not kill process of $1"
	  	    exit 1
	    fi
	  	
	done	

fi

echo "kill process success"