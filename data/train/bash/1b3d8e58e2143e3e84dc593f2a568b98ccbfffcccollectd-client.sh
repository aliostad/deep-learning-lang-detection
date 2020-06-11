#!/bin/bash
read -p "ip server-> " ipserver
echo $ipserver
read -p "hostname->" hostname
echo $hostname
#-----------------------------------------------------------------------
apt-get update && apt-get -y dist-upgrade && apt-get upgrade -y
echo "---------install git-----------------------"
apt-get install git -y
sleep 3
#-------------------------------------------------
echo "-----install collectd-client------------"
apt-get install collectd libjson-perl -y
echo "------Configure collectd -client--------"
filecollectd=/etc/collectd/collectd.conf
#-------------------------------------------------------
test -f $filecollectd.bka || cp $filecollectd $filecollectd.bka
#-------------------------------------------------------- 
rm $filecollectd
#-----------------Tao file moi rong-----------------------------------------
touch $filecollectd
#---------------------------------------------------------------------------
cat << EOF >>  $filecollectd
Hostname $hostname
FQDNLookup true
Interval 10
ReadThreads 5
LoadPlugin syslog
<Plugin syslog>
    LogLevel info
</Plugin>
#LoadPlugin battery
LoadPlugin cpu
LoadPlugin df
LoadPlugin disk
LoadPlugin entropy
LoadPlugin interface
LoadPlugin irq
LoadPlugin load
LoadPlugin memory
LoadPlugin network
LoadPlugin processes
LoadPlugin rrdtool
LoadPlugin swap
LoadPlugin users
<Plugin interface>
  Interface "eth0"
  IgnoreSelected false
</Plugin>
<Plugin network>
    # client setup:
   Server "$ipserver" "2003"
</Plugin>
<Plugin rrdtool>
    DataDir "/var/lib/collectd/rrd"
</Plugin>
#Include "/etc/collectd/filters.conf"
#Include "/etc/collectd/thresholds.conf"
EOF
#------------------------------------------------------------------------
echo "Khoi dong lai collected"
sleep 3
service collectd restart
#-----------------------------------------------------------------------
