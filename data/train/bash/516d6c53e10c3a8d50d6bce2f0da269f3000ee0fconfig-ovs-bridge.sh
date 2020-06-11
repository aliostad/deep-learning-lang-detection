#!/bin/bash
# Bootproto = none

#Inputs: 
# 1. iface name
# 2. Ip addr
# 3. Netmask
# 4. Gateway (optional)
# 5. DNS (optional)

name=$1
ip=$2
netmask=$3
gateway=$4
dns=$5

ifile="/etc/sysconfig/network-scripts/ifcfg-$name"

if [ -f $ifile ]; then
  truncate -s0 $ifile
else
  touch $ifile
fi
# DEVICE
echo "DEVICE=$name" | tee --append $ifile

# deviceTYPE
echo "DEVICETYPE=ovs" | tee --append $ifile

# TYPE
echo "TYPE=OVSBridge" | tee --append $ifile

# Bootproto
echo "BOOTPROTO=none" | tee --append $ifile

# On Boot
echo "ONBOOT=yes" | tee --append $ifile


# IPADDR
echo "IPADDR=$ip" | tee --append $ifile

# Netmask
echo "NETMASK=$netmask" | tee --append $ifile

# Gateway
if [ ! -z $gateway ]; then
echo "GATEWAY=$gateway" | tee --append $ifile
fi

#DNS1
if [ ! -z $dns ]; then
echo "DNS1=$dns" | tee --append $ifile
fi

