#!/bin/bash

set -e

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk>"
    exit 1
fi

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

worker=`hostname`

triplet_file="${QSERV_DUMPS_DIR}/idx_object_${chunk}.tsv"

echo "------------------------------------------------------------------------------------------------"
echo "["`date`"] ** Begin dumping triplets of chunk ${chunk} at worker: ${worker} **"
echo "------------------------------------------------------------------------------------------------"
echo "output file:    ${triplet_file}"

sudo -u qserv rm -f ${triplet_file}

${mysql_cmd} -e "SELECT deepSourceId,chunkId,subChunkId FROM ${OUTPUT_DB}.Object_${chunk} INTO OUTFILE '${triplet_file}'"

echo "total triplets: "`wc -l ${triplet_file} | awk '{print $1}'`
echo "------------------------------------------------------------------------------------------------"
echo "["`date`"] ** Finished dumping triplets of chunk ${chunk} at worker: ${worker} **"
echo "------------------------------------------------------------------------------------------------"
