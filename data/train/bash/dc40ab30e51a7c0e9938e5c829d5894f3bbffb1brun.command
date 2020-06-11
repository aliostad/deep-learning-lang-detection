#!/bin/sh

# Variables
NOW=$(date +"%Y-%m-%d-%H-%M")
LOG="logs/stdout.$NOW.log"
MAIN="readerAdvisor.MainApp"
DEBUG=true

# Create the log directory if it doesn't exist
if [ ! -d logs ]; then
   mkdir -p logs
fi

# Check if the application is running already
check_process(){
   # Get the Process Number
   PROCESS=$(ps axf | grep "$MAIN" | grep -v "grep" | awk "NF=1")
   
   # Echo the process
   if [ $DEBUG ]; then
      echo "$PROCESS"
   fi
   
   # Check if the process exists
   if [ ! -z "$PROCESS" ]; then
      # The process is running
      echo "$PROCESS"
   else
      # The process is not running
      echo ""
   fi

}

# Only run this software if the process is not already running
result=$(check_process)

if [ -z "$result" ]; then
   # Running the Java Application
   nohup java readerAdvisor.MainApp -server -XX:+PrintGCDetails -Dfrontend=epFrontEnd -Dmicrophone[keepLastAudio]=true -DconfigurationFile=script/software.properties > $LOG 2>&1 &
fi

