#!/bin/bash

###############################
#  Initialize /etc/hosts Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

HOSTS_SAMPLE=${SAMPLE_PATH}/cfg_hosts_check.sample
RET=0

cat /etc/hosts > ${HOSTS_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "062 /etc/hosts Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "062 /etc/hosts Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
