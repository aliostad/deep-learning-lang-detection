#!/bin/bash


## The original script is created by JOHN ST. PIERRE at  (abusedcompetence.com)
## I have changed `uptime` command to `cat /proc/loadavg` to get the load average in server
## `uptime` command didn't work if the server is rebooted recently and uptime is in hours instead of days.
## Using `cat /proc/loadavg`, the script will work fine even if the server's uptime is in hours or in days


## All credits goes to JOHN ST. PIERRE at  (abusedcompetence.com)
## More details at ::  http://abusedcompetence.com/2011/03/13/get-automatic-email-or-text-message-alerts-when-your-server-load-is-too-high/


#############################################
# SERVER LOAD ALERT SCRIPT                  #
# BY JOHN ST. PIERRE (abusedcompetence.com) #
# FEEL FREE TO COPY & DISTRIBUTE            #
# USE AT YOUR OWN RISK!                     #
#############################################


########################################
# EDIT THE FOLLOWING FIVE AREAS        #
########################################

# Set your acceptable limit for the 15 minute
# load average. Decimals are acceptable.
limit15=1.00


# Set your acceptable limit for the 5 minute
# load average. Decimals are acceptable.  If
# you don't want 5-minute alerts, just set 
# this to a really high number, like 99.00
limit5=4.00

# Set your acceptable limit for the 1 minute
# load average.  Decimals are acceptable.  
# If you don't want to use this one-minute
# alert, just set the variable below to a  
# really high number,like 99.00.  
limit1=6.00

# Set your text message email address
# This will give you a simple one-line alert
# So you know to go check your server & email
# e.g., Verizon- it's yourphone@vtext.com (e.g. 1234567890@vtext.com)
# e.g., AT&T- it's yourphone@txt.att.net (e.g., 1234567890@txt.att.net)
texting=1234567890@vtext.com

# TO TURN OFF Text Message Alerts, set this to 0.
# Otherwise, leave this setting alone.
gimmetexts=1

# Set your email address
# This will give you an more in-depth report so you
# can investigate the problem quicker
emailadd=you@yourdomain.com


#########################################
# Don't touch ANYTHING BELOW THIS POINT!#
#########################################

alarm=0
load15=`cat /proc/loadavg | cut -d" " -f3`
load5=`cat /proc/loadavg | cut -d" " -f2`
load1=`cat /proc/loadavg | cut -d" " -f1`

float_test() {
     echo | awk 'END { exit ( !( '"$1"')); }'
}

float_test "$load15 > $limit15" && alarm=1
float_test "$load5 > $limit5" && alarm=1
float_test "$load1 > $limit1" && alarm=1

if [ $alarm -gt 0 ]

then
echo "Load average Crossed allowed limit." > ~/load.txt
echo " " >> ~/load.txt
echo "Hostname: $(hostname)" >> ~/load.txt
echo "Local Date & Time : $(date)" >> ~/load.txt 
echo " " >> ~/load.txt
echo "| Uptime status: |" >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
/usr/bin/uptime >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
echo "| Top 20 CPU consuming processes: |" >> ~/load.txt
echo " " >> ~/load.txt
ps aux | head -1 >> ~/load.txt
ps aux --no-headers | sort -rnk 3 | head -20 >> ~/load.txt
echo " " >> ~/load.txt
echo "| Top 10 memory-consuming processes: |" >> ~/load.txt 
echo " " >> ~/load.txt
ps aux | head -1 >> ~/load.txt
ps aux --no-headers | sort -rnk 4 | head -10  >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
echo "| Memory and Swap status: |" >> ~/load.txt
echo " " >> ~/load.txt
/usr/bin/free -m >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
echo "| Active network connection: |" >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
/bin/netstat -tnup | grep ESTA >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
echo "| Disk Space information: |" >> ~/load.txt
echo " " >> ~/load.txt
echo "-------------------------------------------" >> ~/load.txt
echo " " >> ~/load.txt
/bin/df -h >> ~/load.txt
echo " " >> ~/load.txt
echo "-----------END OF REPORT-------------------" >> ~/load.txt

if [ $gimmetexts -gt 0 ]
then
echo "Server load is at $load1 $load5 $load15 !" > ~/notice.txt
mail -s "NOTICE" $texting < ~/notice.txt
fi

mail -s "Server load is at $load1 $load5 $load15" $emailadd < ~/load.txt
rm -f ~/load.txt
rm -f ~/notice.txt

fi
