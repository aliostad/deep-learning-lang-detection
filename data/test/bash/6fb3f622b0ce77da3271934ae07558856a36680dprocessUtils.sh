#!/bin/bash
 
function isProcessExists {
	local processString=$1

	if [ -z "$processString" ]; then
		echo "Process string can not be empty"
		abortScript
		return 1;
	fi

	if [ `ps ax | grep -e "$processString" | grep -v grep | wc -l` -gt 0 ]; then
		echo "Process with string $processString is running"
		return 0 # return success exit code
	fi
	return 1
}

function killProcessByString {
	local processString=$1

	if [ -z "$processString" ]; then
		echo "Process string can not be empty"
		abortScript
	fi

	echo "Searching for processes containing $processString"
	ps ax | grep -e "$processString" | grep -v grep | awk '{print $1}' | while read pid; do
		echo "Process with the PID $pid detected. Killing"
		kill $pid 		
	done
}
