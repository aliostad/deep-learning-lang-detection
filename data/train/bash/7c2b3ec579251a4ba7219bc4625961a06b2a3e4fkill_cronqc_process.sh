#!/bin/bash
echo "*********************************************************************"
echo "# KILL THE PREVIOUS PROCESS CRONTAB cron_qc* -USER sysop             " 
echo "*********************************************************************"
process=$( ps -eaf  | grep cron_qc )
echo "process = "$process
process=$( ps -eaf  | grep cron_qc  |  awk '{print $2}' )
echo "process = "$process
echo "Retry with kill -9 $process to be sure there will no be a problem..."
kill -9 $process
echo off > /home/sysop/work_qc/tools/ae_tools/lock_cron
echo '*********************************************************************'
echo "END $0..." 
echo '*********************************************************************'

