 !/bin/bash

##
#script for system information realted to cpu load memory.
#author= "Ankit Tripathi"
#email= "tankit00@gmail.com"
##
#cpu information gatherd from /proc/cpuinfo
 cpu_info ()
 {
   echo "=======================cpu info========================"
   echo "Number of cpu processor are : $( grep "processor" /proc/cpuinfo | wc -l) "
   echo "Model Name is $(grep "model name" /proc/cpuinfo)" | uniq
   grep "cpu MHz" /proc/cpuinfo
   grep "vendor_id" /proc/cpuinfo | uniq
   grep "cpu cores" /proc/cpuinfo  | uniq
   grep "cache size" /proc/cpuinfo  | uniq 
 }

#cpu load information from  uptime command
cpu_load_info ()
{
    echo "=====================CPU load_at_ info=========================="
    load_at_1=$(uptime | awk  '{print $8}' )
    load_at_5=$(uptime | awk  '{print $9}' )
    load_at_10=$(uptime | awk  '{print $10}')
    echo "load in last 1  min is $load_at_1"
    echo "load in last 5  min is $load_at_5"
    echo "load in last 10 min is $load_at_10"
}

#list of ip addresses assigned to system
network_info ()
{

    echo "=====================Network IP info======================="
    ifconfig |grep  "inet addr" |grep -v "127.0.0.1" |awk '{print "network " $2}'
   
 }

#disk usages info in human readable format
disk_info ()
{
   echo "======================disk info========================"
	   
	df -Th
}

#memory information /proc/meminfo
memory_info ()
{
	echo "======================Memory info========================"
	grep -i "memtotal:" /proc/meminfo | awk '{print $1 $2/1048576 " Gb"}' 
	grep -i "memfree:" /proc/meminfo | awk '{print $1 $2/1048576 " Gb"}' 
	grep -i "MemAvailable:" /proc/meminfo | awk '{print $1 $2/1048576 " Gb"}'        
	grep -i "swaptotal:" /proc/meminfo | awk '{print $1 $2/1048576 " Gb"}'     
	grep -i "swapfree:" /proc/meminfo | awk '{print $1 $2/1048576 " Gb"}'     
}
#function calling
 
cpu_info
cpu_load_info   
memory_info
disk_info
network_info

