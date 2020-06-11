#!/bin/sh

###################################
#  Initialize /etc/profile Configuration
###################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

PROFILE_SAMPLE=${SAMPLE_PATH}/cfg_profile_check.sample
RET=0

cat /etc/profile > ${PROFILE_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "262 /etc/profile Initialization : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    RET=1
  else
    echo "262 /etc/profile Initialization : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
