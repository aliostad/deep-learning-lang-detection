#!/bin/bash

###################################
#  Initialize /etc/group Configuration
###################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

GROUP_SAMPLE=${SAMPLE_PATH}/cfg_group_check.sample
RET=0

cat /etc/group > ${GROUP_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "052 /etc/group Initialization : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    RET=1
  else
    echo "052 /etc/group Initialization : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
