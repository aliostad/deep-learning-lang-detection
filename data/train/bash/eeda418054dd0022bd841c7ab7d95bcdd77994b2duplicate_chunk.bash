#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_partition_stack.bash

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk> [<datadir>]"
    exit 1
fi
datadir="$2"
if [ -z "${datadir}" ]; then

    # Assuming the default destination as per the current
    # configuration of the processing pipeline.

    datadir=$QSERV_DATA_DIR
fi

coldefdir="${SCRIPTS}/../coldef"
indir="${datadir}/dumped/${chunk}"
outdir="${datadir}/duplicated/${chunk}"

htm_level=9
ra_shift=0.1
cmd_coldef_opt="-O ${coldefdir}/Object.coldef -S ${coldefdir}/Source.coldef -F ${coldefdir}/ForcedSource.coldef"
cmd="sph-duplicate2 -v ${cmd_coldef_opt} -l ${htm_level} -i ${indir} -o ${outdir} -t ${ra_shift} -D -N ${chunk}"

rm  -rvf ${outdir}
mkdir -p ${outdir}

on_error() {
    echo "Cleaning up: '${outdir}'"
    rm -rvf "${outdir}"
    exit 1
}
trap on_error 0

echo "Duplicating chunk: ${chunk}"
${cmd}

trap - 0
echo "Cleaning up: '${indir}'"
rm -rvf "${indir}"
