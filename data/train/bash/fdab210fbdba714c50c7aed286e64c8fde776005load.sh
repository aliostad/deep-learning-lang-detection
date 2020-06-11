#!/bin/bash
#This script will send mail alert if load is high in server with w,pstree,mysqladmin,exim queue results

echo "############ SERVER LOAD REPORT ############" > /load.txt
#Enter The Email address
#email="abc@domain.com"

#Enter the Load Average
l="12"

v=`cat /proc/loadavg |awk '{print $1 }' |cut -d"." -f1 `

if [ $v -ge $l ]
then

cd /
touch load.txt

#Enter the Text that you needs to dispaly on mail

echo "Please check the Server and reduce the Load" >> /load.txt
echo "       " >> /load.txt
echo "       " >> /load.txt

echo  "LOAD STATUS RUN ON" `date` >> /load.txt
echo "=================================================================================================" >> /load.txt
echo "=================================================================================================" >> /load.txt

echo " W Results  " >> /load.txt

echo "       " >> /load.txt
echo "       " >> /load.txt
w >> /load.txt
echo "=================================================================================================" >> /load.txt
echo "=================================================================================================" >> /load.txt

echo "TOP Results" >> /load.txt
echo "=================================================================================================" >> /load.txt

#pstree -apu >> load.txt
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -20 >> /load.txt
echo "=================================================================================================" >> /load.txt
echo "=================================================================================================" >> /load.txt
echo "       " >> /load.txt
echo "       " >> /load.txt
echo "MYSQLADMIN Results" >> /load.txt
echo "=================================================================================================" >> /load.txt

echo "       " >> /load.txt
echo "       " >> /load.txt
mysqladmin proc >> /load.txt

echo "=================================================================================================" >> /load.txt
echo "=================================================================================================" >> /load.txt


echo "NETSTAT RESULTS (FOR CHKING DDOS ATTACK..10 HIGH HTTP CONNECTIONS ) " >>/load.txt

echo >>/load.txt
netstat -plan |grep :80 | awk '{print $5}' |cut -d: -f1 |sort |uniq -c |sort -n |tail -10 >>/load.txt

echo "=================================================================================================" >> /load.txt
echo "=================================================================================================" >> /load.txt

echo "       " >> /load.txt
echo "       " >> /load.txt
echo "       " >> /load.txt

mail -s "!!!Urgent HIGH LOAD Avg=$v in  $HOSTNAME " xyx@domain.com abc@domain.com < /load.txt

fi
