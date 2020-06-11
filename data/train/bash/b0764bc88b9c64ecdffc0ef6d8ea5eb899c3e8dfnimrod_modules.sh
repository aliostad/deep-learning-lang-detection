#!/bin/bash
echo -n "Checking NIMROD 'modules' requirements..."
if [ ! -f /etc/profile.d/modules.sh ]; then echo -e "FAILED\nERROR: Modules package is not installed !!!!!\n"; fi;

. /etc/profile.d/modules.sh

if [ ! -f /tmp/build_mod_load ]; then touch /tmp/build_mod_load; chmod 777 /tmp/build_mod_load; fi;

module load nimrod/3.4 2> /tmp/build_mod_load
CHECK_SIZE=`stat -c%s /tmp/build_mod_load`
if [ $CHECK_SIZE -ne 0 ]; then echo -e "FAILED\nERROR: Could not locate nimrod package. Please install it and load it: 'module load nimrod' !!!!!\n"
fi

rm -rf /tmp/build_mod_load

export NIMROD_INSTALL=/usr/local/nimrod/3.4
export NIMROD_DATABASE=pgsql-pool
export NIMROD_HOSTNAME=$(ifconfig eth0 | sed '/inet\ /!d;s/.*r://g;s/\ .*//g')
export PSQL_LOCATION=$(whereis psql | awk '{print substr($2, 0, length($2)-length("/psql"))}')
export PYTHONPATH=${NIMROD_INSTALL}/share/nimrod:${PYTHONPATH}

if [ ! -f ~/.nimrodrc ]; then touch ~/.nimrodrc; fi;
if [ ! -d ~/.nimrod/experiments ]; then mkdir -p ~/.nimrod/experiments; fi;

echo -e "Finished.\n"
