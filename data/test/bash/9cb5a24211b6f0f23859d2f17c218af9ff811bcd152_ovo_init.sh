#!/bin/bash

##########################
# Initialize OVO TEMPLATE
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

OVO_TEMPLATE_SAMPLE=${SAMPLE_PATH}/ovo.template.sample

/opt/OV/bin/opctemplate -l >${OVO_TEMPLATE_SAMPLE}

a=$?

if [ $a -ne 0 ]
  then
    echo "152 OVO TEMPLATE Initialize :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    else
    echo "152 OVO TEMPLATE Initialize :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
 fi


echo "----------------------------------------------------------"
echo


