#!/bin/sh 

APP_HOME="/home/busap/app/etl"
JDK_HOME="/usr/local/java/jdk1.6.0_45"
PIDFILE=$APP_HOME"/bin/etl.pid"
SLEEPFILE=$APP_HOME"/.sleep"


checkRunning(){
        if [ -f "$PIDFILE" ]; then
                if  [ -z "$(cat $PIDFILE)" ];then
                        echo "ERROR: Pidfile '$PIDFILE' exists but contains no pid"
			return 2
		fi
		PID=`cat $PIDFILE`
		RET=`ps -p $PID|grep java`
		if [ -n "$RET" ];then
			return 0;
		else
			return 1;
		fi
	else
		return 1;
        fi
}


invoke_status(){
        if ( checkRunning );then
                PID=`cat $PIDFILE`
		echo "producer is running (pid '$PID')"
		exit 0
	fi
	echo "producer not running"
	exit 1
}


invoke_sleep(){
    if [ ! -f $SLEEPFILE ]; then
        touch $SLEEPFILE
    fi
    echo "producer is sleeping "
    exit 0
}


invoke_wakeup(){
        if [ -f $SLEEPFILE ]; then
                rm -f $SLEEPFILE
        fi
        echo "producer is wakeup "
        exit 0
}



invoke_start(){
        if ( checkRunning );then
                PID=`cat $PIDFILE`
		echo "INFO: Process with pid '$PID' is already running"
		exit 0
	fi
	cd ${APP_HOME}
        ${JDK_HOME}/bin/java -Dfile.encoding=UTF-8 -Djava.ext.dirs=${APP_HOME}/lib -Dconfig=${APP_HOME}/lib/cfg/propertie.properties -Xms128m -Xmx256m com.etl.manager.AppServer & 
	echo $! > $PIDFILE
	exit "$?" 
}


invoke_stop(){
        RET="1"
	if ( checkRunning );then
		RET="$?"
		PID=`cat $PIDFILE`
		FOUND="0"
		i=1
		if [ checkRunning ]; then
			kill $PID
		else
			echo " FINISHED"
				FOUND="1"              
		fi
		while [ $i != "30" ]; do

			if (checkRunning);then
				sleep 1
				printf  "."
			else
				echo " FINISHED"
				FOUND="1"
				break
			fi
			i=`expr $i + 1`
		done
		if [ "$FOUND" -ne "1" ];then
			echo "INFO: Regular shutdown not successful"
			RET="1"
		fi
	elif [ -f "$PIDFILE" ];then
		echo "ERROR: No or outdated process id in '$PIDFILE'"
		echo
		echo "INFO: Removing $PIDFILE"
	else
		echo "producer not running"
		exit 0
	fi
	rm -f $PIDFILE >/dev/null 2>&1
	rm -f $SLEEPFILE >/dev/null 2>&1
	exit $RET
}


show_help() {
  RET="$?"
  cat << EOF
    status          - check if consumer process is running
    stop            - stop running instance (if there is noe)
    start           - start new instance
EOF
  exit $RET
}



if [ -z "$1" ];then
	show_help
fi

case "$1" in
	status)    
		invoke_status
	;;
	sleep)    
		invoke_sleep
	;;
	wakeup)    
		invoke_wakeup
	;;
	start)    
		invoke_start
	;;
	restart)
		if ( checkRunning );then
			$0 stop
		fi
		$0 status
		$0 start
		$0 status
	;;
	stop)    
		invoke_stop
	;;
	*)
		show_help 
esac
