#!/bin/bash

###############################
#  Initialize Kernel Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

CMD=/sbin/lsmod
KMTUNE_SAMPLE=${SAMPLE_PATH}/cfg_kmtune_check.sample
RET=0

$CMD > ${KMTUNE_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "082 Kernel Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "082 Kernel Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
