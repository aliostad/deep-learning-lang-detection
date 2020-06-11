#!/bin/bash
echo -n "Checking BICPL 'modules' requirements..."
if [ ! -f /etc/profile.d/modules.sh ]; then echo -e "FAILED\nERROR: Modules package is not installed !!!!!\n"; fi;

. /etc/profile.d/modules.sh

if [ ! -f /tmp/build_mod_load ]; then touch /tmp/build_mod_load; chmod 777 /tmp/build_mod_load; fi;

module load bicpl/1.4.6 2> /tmp/build_mod_load
CHECK_SIZE=`stat -c%s /tmp/build_mod_load`
if [ $CHECK_SIZE -ne 0 ]; then echo -e "FAILED\nERROR: Could not locate bicpl package. Please install it and load it: 'module load bicpl' !!!!!\n"
fi

rm -rf /tmp/build_mod_load

echo -e "Finished.\n"
