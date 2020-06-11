#! /bin/sh
#
# Usage: build.sh {gcc3/gcc4/icc9/icc91/icc10}
#

# Setting info about sample
SAMPLE_ROOT=`pwd`
SAMPLE_NAME=`expr $SAMPLE_ROOT : ".*/\([^/]\+\)$"`
SAMPLE_OS="linux"
SAMPLE_ARCH="linux32"
SAMPLE_DATE=`date +%Y%m%d`
SAMPLE_SCRIPT=`echo $0 | sed -e 's/\(\.\/\)\(.*\)/\2/g'`
SAMPLE_DIR=`pwd | head -1`
SAMPLE_ROOTS=`pwd | sed -e 's/\(.*\)ipp-samples\/\(.*\)/\1ipp-samples/g'`
SAMPLE_STATUS="-FAILED"
LINKAGE=
rtn=FAILED
LIBx=ar

# Standard environment for all samples set-up
. ${SAMPLE_ROOTS}/tools/env/tools.sh
type_header $SAMPLE_NAME $SAMPLE_DIR $SAMPLE_SCRIPT $SAMPLE_DATE
. ${SAMPLE_ROOTS}/tools/env/env32.sh
SAMPLE_COMP=${COMPILER_NAME}
SAMPLE_LOG_DIR=${SAMPLE_DIR}/log
SAMPLE_LOG=${SAMPLE_DIR}/log/${SAMPLE_NAME}_${SAMPLE_ARCH}_${SAMPLE_COMP}\.log

mkdir -p ${SAMPLE_LOG_DIR}

if [ "${LINKAGE}" == ""  ]; then LINKAGE=dynamic; fi

make ARCH=${SAMPLE_ARCH} COMP=${SAMPLE_COMP} CC=${CC} CXX=${CXX} clean
make ARCH=${SAMPLE_ARCH} COMP=${SAMPLE_COMP} CC=${CC} CXX=${CXX} IPPROOT=${IPPROOT} LIBx=${LIBx} build 2>&1 >> $SAMPLE_LOG && rtn=PASSED

# detecting results of MAKE
printf "%-30s %s\n" $SAMPLE_NAME $rtn

if [ "$rtn" == "PASSED" ]; then
	SAMPLE_STATUS="-OK"
else
	SAMPLE_STATUS="-FAILED"
fi

type_footer $SAMPLE_NAME $DATE_TIME $SAMPLE_STATUS