#!/bin/bash
#
# Script ummsdb.sh
# Rebuild the UMMS database.

dropdb umms
createdb umms
psql umms < $ALT1_CAR_HOME/data/mpsCommonSchema.sql
psql umms < $ALT1_CAR_HOME/data/mpsCVSchema.sql
python $ALT1_CAR_HOME/commands/cvLoad.py -d umms -s dev
if [ $? -eq 0 ]
then
  echo "cv load successful"
else
  echo "cv load failed" >&2
  exit
fi
psql umms < $ALT1_CAR_HOME/data/mpsAtramSchema.sql
python $ALT1_CAR_HOME/commands/atramLoad.py -d umms -s umms
if [ $? -eq 0 ]
then
  echo "atram load successful"
else
  echo "atram load failed" >&2
  exit
fi
python $ALT1_CAR_HOME/commands/workflowLoad.py -d umms -s umms
if [ $? -eq 0 ]
then
  echo "workflow load successful"
else
  echo "workflow load failed" >&2
  exit
fi

psql umms < $ALT1_CAR_HOME/misc/atramdummy2.sql
