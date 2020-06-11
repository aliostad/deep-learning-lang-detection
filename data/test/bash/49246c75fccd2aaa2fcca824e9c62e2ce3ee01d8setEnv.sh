#!/bin/sh
# *************************************************************************
# Set SIPP env for load tests
# *************************************************************************

# TO ADAPT
SIPP_HOME="/usr/local/sipp.svn"

# The limit for the load message
NB_LOAD_MESSAGE="5000000000"
NB_LOAD_MESSAGE="10000000"
#NB_LOAD_MESSAGE="1"

AS=192.168.2.217

SIPP_UAC_IP=tenerife
SIPP_UAS_IP=tenerife

UAC_PORT=5062

UAS_PORT=5063

SIPP_OPTIONS="-t u1"

# default -trace_err -trace_screen
# for debugging  -trace_msg
TRACE_OPTIONS=" -trace_screen"

UAC_SPECIFIC_OPTIONS="-l 200000"


LOAD_CALL_RATE=100
RATE_PERIOD=100

echo "The load call rate is set to ${LOAD_CALL_RATE} for a rate period of ${RATE_PERIOD}"

SIPP=${SIPP_HOME}/sipp

UAC_SCRIPT="${SIPP_UAS_IP}:${UAS_PORT} -m ${NB_LOAD_MESSAGE} -r ${LOAD_CALL_RATE} -rp ${RATE_PERIOD} \
                  ${SIPP_OPTIONS} -i ${SIPP_UAC_IP} -p ${UAC_PORT} -sf ../uac.xml ${TRACE_OPTIONS} \
                  ${UAC_SPECIFIC_OPTIONS} -rsa ${AS}"

UAS_SCRIPT="-i ${SIPP_UAS_IP} -p ${UAS_PORT} ${SIPP_OPTIONS} -sf ../uas.xml ${TRACE_OPTIONS}"
