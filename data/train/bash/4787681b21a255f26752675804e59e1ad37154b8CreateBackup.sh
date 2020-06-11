#!/bin/sh
DIR=`date '+%s'`
mkdir $DIR
mv *.csv ./$DIR/
cp ActiveProcess_Template.txt ActiveProcess_ContentAPIApplicationServices.csv
cp ActiveProcess_Template.txt ActiveProcess_CRSApplicationServices.csv
cp ActiveProcess_Template.txt ActiveProcess_OrchestrationService.csv
cp ActiveProcess_Template.txt ActiveProcess_TIMSApplicationServices.csv
touch AverageTimeMonitor.csv
echo Time,ProcessDefinitionName,ActivityName,ExecutionCount,ExecutionSinceReset,TotalElapsed,MinElapsed,AverageElapsed,MaxElapsed,RecentElapsed,TotalError >> /opt/tibco/monitor/AverageTimeMonitor.csv
touch tda_monitor_elapsedtime.csv
echo Time,ProcessName,Activity,ElapsedTime >> tda_monitor_elapsedtime.csv
