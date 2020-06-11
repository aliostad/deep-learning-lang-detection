#!/usr/bin/env bash

# This script checks if KA Lite is loaded and exits with non-zero if it does.
# This is required by the .pkg before it continues with the install process.


# Print message in terminal and log for the Console application.
function msg() {
    echo "$1"
    syslog -s -l alert "KA-Lite: $1"
}


PROCESS="/Applications/KA-Lite*"

msg "Checking for a loaded '$PROCESS'..."

# REF: http://stackoverflow.com/a/1821897/845481 
# Check if Mac process is running using Bash by process name
number=$(ps aux | grep "$PROCESS" | grep -v "grep" | wc -l)
if [ $number -gt 0 ]; then
    msg ".. Found a loaded '$PROCESS', please quit it before running the installer."
    exit 1
fi

msg ".. No loaded '$PROCESS' found."
exit 0
