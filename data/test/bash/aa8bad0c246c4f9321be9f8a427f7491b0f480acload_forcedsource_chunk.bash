#!/bin/bash

set -e

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk>"
    exit 1
fi

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_qserv_stack.bash

worker=`/usr/bin/hostname`

config_dir="${SCRIPTS}/../config"
data_dir="${QSERV_DATA_DIR}/partitioned/${chunk}/ForcedSource"

loader=`which qserv-data-loader.py`

opt_verbose="--verbose --verbose --verbose --verbose-all"
opt_conn="--host=${MASTER} --port=5012 --secret=${config_dir}/wmgr.secret --no-css"
opt_config="--config=${config_dir}/common.cfg --config=${config_dir}/ForcedSource.cfg"
opt_db_table_schema="${OUTPUT_DB} ForcedSource ${config_dir}/ForcedSource.sql"
opt_data="--skip-partition --chunks-dir=${data_dir}"

echo "----------------------------------------------------------------------------------------"
echo "["`date`"] ** Begin loading chunk ${chunk} at worker: ${worker} **"
echo "----------------------------------------------------------------------------------------"

loadercmd="${loader} ${opt_verbose} ${opt_conn} --worker=${worker} ${opt_config} ${opt_data} ${opt_db_table_schema}"

echo ${loadercmd}
${loadercmd}

echo "["`date`"] ** Finished loading chunk ${chunk} at worker: ${worker} **"

