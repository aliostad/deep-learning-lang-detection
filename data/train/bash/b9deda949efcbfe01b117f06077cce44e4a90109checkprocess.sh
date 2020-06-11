#!/bin/bash
#------------------------------------------------------------
#This script is to check a particular process on the system 
#if the process is not running it will try to restart it.
#this script will check for "rpcbind" by default
#USAGE : ./checkprocess.sh <process> <path to program>
#EXAMPLE :./checkprocess.sh rpcbind /etc/init.d/
#------------------------------------------------------------
a=`pgrep $1`;
if [ $a ]
then 
echo "The process $1 is running ";
else 
$2/$1 &
#echo "NOT running";
fi
     
