#!/usr/bin/env bash

#***********************************************
#  Name: start.sh
#  Date: 9 Nov 2014
#  Usage: ./start.sh -port=8080 -nioport=8443 -env=prod
#  EXIT Code: 1, for some error else 0
#**********************************************

#To Show the message
usage(){

  echo "Usage : $0 -p <port_to_start> -n <nioport> -e <env>
        port_to_start : Tomcat to start on this port, default 8080
        nioport : ssl port
        env :  prod OR dev, default prod"

}

#Invoke app process
invoke_app(){
    JAVA_OPTS="-Denv=$env_to_use -Dport=$port -Dnioport=$nioport" nohup ../bin/uim_api_explorer_conf > /dev/null 2>&1 &
    running_pid=$!;
    return $running_pid;
}

if [[ $1 == "-h" || $1 == --help ]]; then
  usage
else
    while getopts ":p:n:e:" opt;
        do
            case $opt in
                p|--port) port=$OPTARG;;
                n) nioport=$OPTARG;;
                e) env_to_use=$OPTARG;;
                \?) echo "Invalid option";
                    exit 1;
                    ;;

                :) echo "Option -$OPTARG requires an argument." >&2
                    exit 1;
                    ;;
            esac
        done
fi
#Now Invoke application
invoke_app;
echo "App Starting at $running_pid";
exit 0;