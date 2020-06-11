#!/bin/bash

MONGO_SERVER=localhost
MONGO_PORT=30011

LOG_NAME=movechunk.log
rm -f $LOG_NAME

# move a chunk from shard0001 to shard0000
T="$(date +%s)"
$MONGO_DIR/bin/mongo admin --host ${MONGO_SERVER} --port ${MONGO_PORT} --eval "printjson(sh.moveChunk(\"sbtest.sbtest\", {collectionId:  1, documentId: 1}, \"shard0001\"));" | tee -a $LOG_NAME
T="$(($(date +%s)-T))"
echo "`date` | moveChunk seconds = ${T}" | tee -a $LOG_NAME

# move a chunk from shard0002 to shard0001
T="$(date +%s)"
$MONGO_DIR/bin/mongo admin --host ${MONGO_SERVER} --port ${MONGO_PORT} --eval "printjson(sh.moveChunk(\"sbtest.sbtest\", {collectionId:  2, documentId: 1}, \"shard0002\"));" | tee -a $LOG_NAME
T="$(($(date +%s)-T))"
echo "`date` | moveChunk seconds = ${T}" | tee -a $LOG_NAME

# move a chunk from shard0000 to shard0002
T="$(date +%s)"
$MONGO_DIR/bin/mongo admin --host ${MONGO_SERVER} --port ${MONGO_PORT} --eval "printjson(sh.moveChunk(\"sbtest.sbtest\", {collectionId: 3, documentId: 1}, \"shard0000\"));" | tee -a $LOG_NAME
T="$(($(date +%s)-T))"
echo "`date` | moveChunk seconds = ${T}" | tee -a $LOG_NAME


