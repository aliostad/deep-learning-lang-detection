#!/bin/bash

USAGE="Usage: $0 {processID|process_name} [<label>]"

if [ $# -gt 2 ]; then
   echo $USAGE
   exit 1
fi
if [ $# -eq 0 ]; then
   echo $USAGE
   exit 1
fi

# In case the monitored process has not yet started
# keep searching until its PID is found
pname=$1
label=$2
MACHINE=`hostname`
by_name=0
PROCESS_PID=""
if [ "$label.X" = ".X" ]; then
    label="$pname"
fi
LOG_FILE="memwatch.$label.$MACHINE.tab"
echo "Logfile=$LOG_FILE"
echo "" > $LOG_FILE
expr "$pname" + 1 2> /dev/null
if [ $? -eq 0 ]; then
  #numeric argument
  PROCESS_PID=$pname
 else
  by_name=1
  # process name given
  # wait for process to appear
  PROCESS_PID=`/sbin/pidof -s -x $pname`
  if [ "$PROCESS_PID.X" = ".X" ]; then
     echo "Waiting for process '$pname' to appear"
     echo "# Waiting for process '$pname' to appear" >> $LOG_FILE
     while :
     do
        PROCESS_PID=`/sbin/pidof -s -x $pname`
        if [ "$PROCESS_PID.X" != ".X" ]; then
           break
        fi
     sleep 1
     done
     fi
fi

echo "# PID 	Time             	VmSize   	VmRSS" >> $LOG_FILE

ELAPSED_TIME=`date +%H:%M:%S`
PERIOD=2        # seconds
prev_size=0
prev_rss=0
nr_msg=1
nr_waitmsg=1
while :
do
 if [ -d /proc/$PROCESS_PID ]; then
   VM_SIZE=`awk '/VmSize/ {print $2}' < /proc/$PROCESS_PID/status`
   if [ "$VM_SIZE.X" = ".X" ]; then
      continue
   fi
   VM_RSS=`awk '/VmRSS/ {print $2}' < /proc/$PROCESS_PID/status`
   if [ "$VM_RSS.X" = ".X" ]; then
      continue
   fi
   if [ $VM_RSS = $prev_rss ]; then
     sleep $PERIOD
     continue
   fi
   echo "$PROCESS_PID	$ELAPSED_TIME	$VM_SIZE	$VM_RSS" >> $LOG_FILE
   sleep $PERIOD
   prev_rss=$VM_RSS
   VM_SIZE=""
   VM_RSS=""
   ELAPSED_TIME=`date +%H:%M:%S`
 else
   if [[ $nr_msg ]]; then
     echo "# $PROCESS_PID is no longer a running process." >> $LOG_FILE
     nr_msg=""
     fi
   # if the name give was a label
   if [ $by_name -eq 1 ]; then
     if [[ $nr_waitmsg ]]; then
        echo "# Waiting for process '$pname' to reappear.." >> $LOG_FILE
        nr_waitmsg=""
        fi
     while :
        do
        PROCESS_PID=`/sbin/pidof -s -x $pname`
        if [ "$PROCESS_PID.X" != ".X" ]; then
           break
           fi
        sleep 1
        done
     if [ "$PROCESS_PID.X" != ".X" ]; then
       continue
       fi
     fi
 fi
done
