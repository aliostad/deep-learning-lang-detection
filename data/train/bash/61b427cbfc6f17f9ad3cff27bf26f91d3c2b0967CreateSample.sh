#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="Tinc"
QPKG_PATH=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)
TINCD="$QPKG_PATH/tincd"
LOG_TOOL=/sbin/log_tool

# Check /share/Tinc/sample doesn't exist
if [ -d /share/Tinc/sample ]
then
  # sample dir already exists
  exit 
fi

# cp -a $QPKG_PATH/sample to /share/Tinc/sample
cp -a $QPKG_PATH/sample /share/Tinc/sample

# Generate an IP Address likely to be unique.
# eg: 172.16.#.#/32 where #.# is based on Mac address
# ip link show eth0 | grep link/ether | awk '{print $2}'
# python -c 'print(int("FF", 16))'

mac=`ip addr show dev eth0 | grep ether | awk '{print $2}'`
mac5=`echo $mac | cut -d : -f 5`
mac6=`echo $mac | cut -d : -f 6`
quadC=`python -c "print(int(\"$mac5\", 16))"`
quadD=`python -c "print(int(\"$mac6\", 16))"`

# sed s/HostName/$HOSTNAME/g in tinc.conf.sample, subnet-{up,down}, and hosts/HostName
sed -i "s/HostName/$HOSTNAME/g" /share/Tinc/sample/tinc.conf.sample
sed -i "s/HostName/$HOSTNAME/g" /share/Tinc/sample/subnet-up
sed -i "s/HostName/$HOSTNAME/g" /share/Tinc/sample/subnet-down
sed -i "s/HostName/$HOSTNAME/g" /share/Tinc/sample/hosts/HostName

# sed s/IPv4Address/172.16.#.#/g tinc-up and hosts/HostName
sed -i "s/IPv4Address/172.16.${quadC}.${quadD}/g" /share/Tinc/sample/tinc-up
sed -i "s/IPv4Address/172.16.${quadC}.${quadD}/g" /share/Tinc/sample/hosts/HostName

# rename hosts/HostName to $HOSTNAME
mv /share/Tinc/sample/hosts/HostName "/share/Tinc/sample/hosts/${HOSTNAME}"

# generate keys: tind --generate-keys
# make sure it doesn't block on input

# Enable this config briefly
mv /share/Tinc/sample/tinc.conf.sample /share/Tinc/sample/tinc.conf

# input /dev/null to bypass prompt for file name
$TINCD --config=/share/Tinc/sample/ --generate-key < /dev/null

# Disable the sample configuration
mv /share/Tinc/sample/tinc.conf /share/Tinc/sample/tinc.conf.sample

