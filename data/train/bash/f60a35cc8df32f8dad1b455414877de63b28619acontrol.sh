#! /bin/sh

# # # # # # # # # # # # # # # # # # # # # # # # 
# 控制脚本，使用方法:bash control.sh start|restart|stop
# version:1.0
# # # # # # # # # # # # # # # # # # # # # # # # 

BASEDIR="/home/testenv/protocol_server/"

if [ $# -lt 1 ]; then
	echo "usage: bash control.sh start|restart|stop"
	exit
fi

start(){

	#chech process file is exists
	if [ -f ${BASEDIR}lib/process_file ]; then
		echo "process file is exists!"
		exit
	else
		echo "everything is ok! let's go!!!"

	fi

	#start
	nohup python ${BASEDIR}Listen_port.py > /dev/null
}


stop(){
	#get process id from file
	if [ -f ${BASEDIR}lib/process_file ]; then
		process_id=`cat ${BASEDIR}lib/process_file`
		if [ -n $process_id ]; then
			kill -9 $process_id
		else
			echo "process id is not exist! contact admin!"
			exit
		fi
	else
		echo "process id file is not exist! contact admin!"
		exit
	fi
	
	#remove process id file
	rm -f ${BASEDIR}lib/process_file

}

case $1 in

"start" )

	start;;

"stop" )

	stop;;	

"restart" )
	stop
	start;;

esac
