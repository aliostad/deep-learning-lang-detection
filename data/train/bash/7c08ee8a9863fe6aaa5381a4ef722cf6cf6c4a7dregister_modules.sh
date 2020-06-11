#!/bin/bash
echo -n "Checking REGISTER 'modules' requirements..."
if [ ! -f /etc/profile.d/modules.sh ]; then echo -e "FAILED\nERROR: Modules package is not installed !!!!!\n"; fi;

. /etc/profile.d/modules.sh

if [ ! -f /tmp/build_mod_load ]; then touch /tmp/build_mod_load; chmod 777 /tmp/build_mod_load; fi;

module load register/1.4.0 2> /tmp/build_mod_load
CHECK_SIZE=`stat -c%s /tmp/build_mod_load`
if [ $CHECK_SIZE -ne 0 ]; then echo -e "FAILED\nERROR: Could not locate register package. Please install it and load it: 'module load register' !!!!!\n"
fi

rm -rf /tmp/build_mod_load

echo -e "Finished.\n"
