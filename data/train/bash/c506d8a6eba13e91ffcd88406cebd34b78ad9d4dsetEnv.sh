#!/bin/sh
# *************************************************************************
# Set SIPP env for load tests
# *************************************************************************

# TO ADAPT
SIPP_HOME="/home/nicolas/test/sipp-3.1"

# The limit for the load message
NB_LOAD_MESSAGE="5000000"
#NB_LOAD_MESSAGE="1"

AS=192.168.2.207:5060

SIPP_IP=192.168.2.207

UAC_PORT=5062

UAS_PORT=5063

SIPP_OPTIONS=""

# default -trace_err -trace_screen
# for debugging  -trace_msg
TRACE_OPTIONS="-trace_err -trace_screen"

UAC_SPECIFIC_OPTIONS="-l 200000 -mp 6004"

LOAD_CALL_RATE=10
RATE_PERIOD=1000

echo "The load call rate is set to ${LOAD_CALL_RATE} for a rate period of ${RATE_PERIOD}"

SIPP=${SIPP_HOME}/sipp

UAC_SCRIPT="${SIPP_IP}:${UAS_PORT} -m ${NB_LOAD_MESSAGE} -r ${LOAD_CALL_RATE} -rp ${RATE_PERIOD} \
                  ${SIPP_OPTIONS} -i ${SIPP_IP} -p ${UAC_PORT} -sf ../uac.xml ${TRACE_OPTIONS} \
                  ${UAC_SPECIFIC_OPTIONS} -rsa ${AS}" 
                  
UAS_SCRIPT="-i ${SIPP_IP} -p ${UAS_PORT} ${SIPP_OPTIONS} -sf ../uas.xml ${TRACE_OPTIONS}"

