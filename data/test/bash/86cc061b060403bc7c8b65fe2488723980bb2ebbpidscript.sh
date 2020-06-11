#!/bin/bash
#Author   	Piotr Pruski
PIDFILE="myprocess.pid"
MYPID=`echo $$`
PROCESS="/usr/bin/google-chrome"


function check_status ( )
{
SERVICE=$BABYPID
RESULT=`ps -a | sed -n /${SERVICE}/p`

if [ "${RESULT:-null}" = null ]; then
#    echo "Not running"
    return 1;
else
#    echo "Running"
    return 0;
fi
}

function check_file_exist ( )
{
if [ -f $PIDFILE ] 
then
	if [ -s $PIDFILE ] 
	then
#	   	echo "PID file exist"
        BABYPID=`cat myprocess.pid`
        #echo $BABYPID
        check_status $BABYPID
		if [ $? -eq 1 ]
		then
			return 1
		fi
	else
        create_process
#	   	echo "PID file created"
	fi
else
#	echo "PID file dosen't exits"
	return 1;
fi

}

function create_process ()
{
#	./ohh.sh &
	$PROCESS &
	echo $! > $PIDFILE
#	PID=`ps -eo pid,command | grep ohh.sh | grep -v grep | awk '{print $1}'`
#	echo $PID > $PIDFILE
}

function kill_process ()
{
	echo "Kill process"
	kill `cat $PIDFILE`
	sleep 2
	check_file_exist
	if [ $? -eq 0 ]
	then 
		echo "Kill them All!!"
		kill -9 `cat $PIDFILE`
	fi
}

function restart_process ()
{
	echo "Restart process"
	check_file_exist
	if [ $? -eq 1 ]
	then
		echo "Bagabum"
	else
		kill_process
		create_process
	fi
}	

case $1 in
start) 
check_file_exist
if [ $? -eq 1 ]
then
    create_process
else
    echo "false"
fi
;;
stop) 
check_file_exist 
if [ $? -eq 1 ]
then
	echo "Process is not running"
else
	echo "Please kill process"
	kill_process
fi
;;
status) 
check_file_exist 
if [ $? -eq 1 ]
then
	echo "Process not running"
else
	echo "Process is running"
fi
;;
restart) restart_process ;;
*) 
echo "Invalid argument" ;
echo "$0 usages: start, stop, status, restart" 
esac

if [ $? -eq 0 ] 
then
 	echo "DONE"
else
	echo "FAIL"
fi
