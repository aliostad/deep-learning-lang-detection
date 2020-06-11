#!/bin/sh
#
#  COPYRIGHT (C) 2003-2008 Opulan Technologies Corp. ALL RIGHTS RESERVED.
#
#  Reference Design System watch dog script
#

echo "Opulan watch dog starting ..."

if [ -z $1 ]; then
	echo "Target application can not be null!"
	echo "Usage: $0 <target app>"
	exit 1
fi

APP_PROCESS=`echo $1 | awk -F'/' '{print $NF}'`

# wait 20 seconds to give enough time to start up target app
sleep 20

APP_PROCESS_ID=`ps | grep $APP_PROCESS | grep -v grep | grep -v watchdog | grep [RS] | awk -F" " '{if (NR==1) {m=$1} else if (NR==2) {print m}}'`
echo "$APP_PROCESS process id is: $APP_PROCESS_ID"
sleep 1

while [ $APP_PROCESS_ID ] ; do
	sleep 1
	APP_PROCESS_ID=`ps | grep $APP_PROCESS | grep -v grep | grep -v watchdog | grep [RS] | awk -F" " '{if (NR==1) {m=$1} else if (NR==2) {print m}}'`
#	echo "$APP_PROCESS process id is: $APP_PROCESS_ID"
done

echo "Detect process $1 failed"
sleep 1
echo "System rebooting ..."
reboot

