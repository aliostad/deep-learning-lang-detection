#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIB=$DIR/../../lib/lib.sh

echo "Testing checkProcessRunning"

processName="getty"
numberOfProcesses=$($LIB checkProcessRunning $processName)

if [ $numberOfProcesses -gt 0 ]
then
	echo "Process $processName running [TEST PASSED]"
else
	echo "Process $processName is not running [TEST FAILED]"
fi


processName="askljdfhlakjsdhflaj"
numberOfProcesses=$($LIB checkProcessRunning $processName)

if [ $numberOfProcesses -gt 0 ]
then
        echo "Process $processName running [TEST FAILED]"
else
        echo "Process $processName is not running [TEST PASSED]"
fi

