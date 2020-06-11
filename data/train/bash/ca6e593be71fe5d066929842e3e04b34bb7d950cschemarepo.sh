#!/bin/bash
#

PRG="${0}"
BASEDIR=`dirname ${PRG}`
BIN_DIR=$BASEDIR

source ${BIN_DIR}/env.sh

if [ "$SCHEMA_REPO_HOME" == "" ]; then
    SCHEMA_REPO_HOME=`cd ${BIN_DIR}/..;pwd`
fi

LIB=${SCHEMA_REPO_HOME}/lib
if [ "$SCHEMA_REPO_LOG_DIR" == "" ]; then
    SCHEMA_REPO_LOG_DIR=${SCHEMA_REPO_HOME}/logs
fi

if [ "$SCHEMA_REPO_CONF_DIR" == "" ]; then
    SCHEMA_REPO_CONF_DIR=$SCHEMA_REPO_HOME/conf
fi

# prepend conf dir to classpath
if [ -n "$SCHEMA_REPO_CONF_DIR" ]; then
  CLASS_PATH="$SCHEMA_REPO_CONF_DIR:$CLASS_PATH"
fi

CLASS_PATH=${CLASS_PATH}:${LIB}/'*'

if [ "$SCHEMA_REPO_JAVA_OPT" == "" ]; then
    SCHEMA_REPO_JAVA_OPT="-Xms2048m -Xmx4096m"
fi

JAVA=$JAVA_HOME/bin/java
exec "$JAVA" ${SCHEMA_REPO_JAVA_OPT} -cp ${CLASS_PATH} -Dlog.dir=${SCHEMA_REPO_LOG_DIR} com.nexr.server.DipSchemaRepoServer start

