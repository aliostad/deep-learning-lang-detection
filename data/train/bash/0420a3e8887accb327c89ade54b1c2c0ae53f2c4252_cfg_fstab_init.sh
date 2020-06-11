#!/bin/sh

###################################
#  Initialize /etc/fstab Configuration
###################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

FSTAB_SAMPLE=${SAMPLE_PATH}/cfg_fstab_check.sample
RET=0

cat /etc/fstab > ${FSTAB_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "252 /etc/fstab Initialization : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    RET=1
  else
    echo "252 /etc/fstab Initialization : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
