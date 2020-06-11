#!/bin/bash

#SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
#TODO make this more robust
#read environmental configuration
. *.env
SPRING_OPTS="-DLOG_FILE=$LOG_FILE -Dspring.profiles.active=$spring_profiles_active"
function check_if_pid_file_exists {
if [ ! -f $PID_FILE ]
then
echo "PID file not found: $PID_FILE"
exit 0
fi
}
function check_if_process_is_running {
if ps -p $(print_process) > /dev/null
then
return 0
else
return 1
fi
}
function print_process {
echo $(<"$PID_FILE")
}
case "$1" in
status)
check_if_pid_file_exists
if check_if_process_is_running
then
echo $(print_process)" is running"
else
echo "Process not running: $(print_process)"
fi
;;
stop)
check_if_pid_file_exists
if ! check_if_process_is_running
then
echo "Process $(print_process) already stopped"
exit 0
fi
kill -TERM $(print_process)
echo -ne "Waiting for process to stop"
NOT_KILLED=1
for i in {1..20}; do
if check_if_process_is_running
then
echo -ne "."
sleep 1
else
NOT_KILLED=0
fi
done
echo
if [ $NOT_KILLED = 1 ]
then
echo "Cannot kill process $(print_process)"
exit 1
fi
echo "Process stopped"
;;
start)
if [ -f $PID_FILE ] && check_if_process_is_running
then
echo "Process $(print_process) already running"
exit 1
fi
nohup /drillmap/java/bin/java $SPRING_OPTS -jar $JAR_FILE  >/dev/null 2>&1 &
echo "Process started"
;;
restart)
$0 stop
if [ $? = 1 ]
then
exit 1
fi
$0 start
;;
*)
echo "Usage: $0 {start|stop|restart|status}"
exit 1
esac
exit 0