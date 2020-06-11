#!/bin/bash


export PLAT_HOME=/usr/local/edw/platform
export HWW_HOME=/usr/etl/HWW

source $PLAT_HOME/common/sh_helpers.sh
source $PLAT_HOME/common/sh_metadata_storage.sh

PROCESS_NAME="ETL_HCOM_HEX_TRANSACTIONS_BKG"
_LOG "PROCESS_NAME=[$PROCESS_NAME]"

ERROR_CODE=0

PROCESS_ID=$(_GET_PROCESS_ID "$PROCESS_NAME");
RETURN_CODE="$?"

if [ "$PROCESS_ID" == "" ] || (( $RETURN_CODE != 0 )); then
  _LOG "ERROR: Process [$PROCESS_NAME] does not exist in HEMS"
  ERROR_CODE=1
  _FREE_LOCK $HWW_TRANS_BKG_LOCK_NAME
  exit 1;
else
  RUN_ID=$(_RUN_PROCESS $PROCESS_ID "$PROCESS_NAME")
  _LOG "PROCESS_ID=[$PROCESS_ID]"
  _LOG "RUN_ID=[$RUN_ID]"
fi

BOOKMARK=`_READ_PROCESS_CONTEXT $PROCESS_ID "BOOKMARK"`
PROCESSING_TYPE=`_READ_PROCESS_CONTEXT $PROCESS_ID "PROCESSING_TYPE"`
EMAIL_TO=`_READ_PROCESS_CONTEXT $PROCESS_ID "EMAIL_TO"`
EMAIL_CC=`_READ_PROCESS_CONTEXT $PROCESS_ID "EMAIL_CC"`

EMAIL_RECIPIENTS=$EMAIL_TO
if [ $EMAIL_CC ]
then
  EMAIL_RECIPIENTS="-c $EMAIL_CC $EMAIL_RECIPIENTS"
fi


_LOG "PROCESSING_TYPE=$PROCESSING_TYPE"
_LOG "BOOKMARK=$BOOKMARK"

if [ $PROCESSING_TYPE = "R" ]; then
  export END_DATE=$BOOKMARK
else
  export END_DATE=`date --date="${BOOKMARK} +1 days" '+%Y-%m-%d'`
fi

source $HWW_HOME/common/sh_hww_helpers.sh

export ENTITY=$1

_LOG "running source data availability check for: entity = $ENTITY and data = $END_DATE"
_DBCONNECT

STATUS=$($DB2_HOME/sqllib/bin/db2 -x "select count(*) from etl.etl_fileprocess where entity = '$ENTITY' and data = '$END_DATE' with ur")
ERROR_CODE=$?

_DBDISCONNECT

if [[ $ERROR_CODE -eq 0 && $STATUS -eq 1 ]]; then
  echo "[$ENTITY] has completed"
  exit 0
else
  echo "[$ENTITY] has not completed"
  echo -e "====================================================================================================================================================================\ncheck_entity_hex.sh failed: No new data available from BOOKMARK=[${BOOKMARK}] in source.\nCheck source data availability (Refer to documentation : https://confluence/pages/viewpage.action?pageId=420855780)\n\nScript Name : $0\n====================================================================================================================================================================" | mailx -s "HWW HEX Alert (ETL_HCOM_HEX_TRANSACTIONS_BKG): No incremental data in source to process (Last Bookmark Date - ${BOOKMARK})" $EMAIL_RECIPIENTS
  exit 1
fi
