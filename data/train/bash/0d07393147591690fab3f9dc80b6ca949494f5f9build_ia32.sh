#!/usr/bin/env bash

##
##                  INTEL CORPORATION PROPRIETARY INFORMATION
##     This software is supplied under the terms of a license agreement or
##     nondisclosure agreement with Intel Corporation and may not be copied
##     or disclosed except in accordance with the terms of that agreement.
##          Copyright(c) 2007-2010 Intel Corporation. All Rights Reserved.
##

#
# Usage: buildXX.sh [ gcc3 | gcc4 | icc111 | icc120 ]
#

# Setting info about sample
SAMPLE_ROOT=`pwd`
SAMPLE_NAME=${SAMPLE_ROOT##*/}
SAMPLE_OS="linux"
SAMPLE_ARCH="ia32"
SAMPLE_DATE=`date +%Y%m%d`
SAMPLE_SCRIPT=${0##*/}
SAMPLE_DIR=`pwd | head -1`
SAMPLE_ROOTS=`pwd | sed -e 's/\(.*\)ipp-samples\/\(.*\)/\1ipp-samples/g'`
SAMPLE_STATUS="-FAILED"


# Standard environment for all samples set-up
. ${SAMPLE_ROOTS}/tools/env/env_ia32.sh

SAMPLE_COMP=${COMPILER_NAME}
SAMPLE_LOG_DIR=${SAMPLE_DIR}/log
SAMPLE_LOG=${SAMPLE_DIR}/log/${SAMPLE_NAME}_${SAMPLE_ARCH}_${SAMPLE_COMP}\.log

mkdir -p ${SAMPLE_LOG_DIR}

make ARCH=${SAMPLE_ARCH} COMP=${SAMPLE_COMP} CC=${CC} CXX=${CXX} clean
make ARCH=${SAMPLE_ARCH} COMP=${SAMPLE_COMP} CC=${CC} CXX=${CXX} LINKAGE=${LINKAGE} IPPROOT=${IPPROOT} && SAMPLE_STATUS="-OK"
