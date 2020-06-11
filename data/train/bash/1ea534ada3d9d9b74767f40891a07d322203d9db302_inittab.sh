#!/bin/sh

###################################
#  Initialize /etc/inittab Configuration
###################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

PROFILE_SAMPLE=${SAMPLE_PATH}/inittab_check.sample
RET=0

cat /etc/inittab > ${PROFILE_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "302 /etc/inittab Initialization : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    RET=1
  else
    echo "302 /etc/inittab Initialization : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
