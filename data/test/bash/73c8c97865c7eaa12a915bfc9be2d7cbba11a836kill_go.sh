
###############################################
# kill go process launch by Go.sublme-build
# 
# Author: liudanking and Mark Xu
# 
# Current Version 2014.06.13 V0.1.0.2
# History Version 2014.06.12 V0.1.0.1
# History Version 2014.06.12 V0.1.0.0
###############################################

function kill_process {
	PID=`ps -A | grep -m1 $1 | grep -v grep | grep -v kill_go | awk '{print $1}'`
	if [ "$PID" = "" ]
	then
		echo "[$1] is not launched"
	else
		kill $PID
		echo "[$1] is killed"
	fi
}

process_name=$1
kill_process $process_name
process_name="exe/$2"
kill_process $process_name
