#!/bin/bash

trap 'echo "$0:$LINENO \"$BASH_COMMAND\"" ; exit 1' ERR

BASE_DIR=`pwd`
REBAR=${BASE_DIR}/rebar
WORK_DIR=${BASE_DIR}/sample

echo "Clean up working directory..."
rm -rf ${WORK_DIR} && mkdir -p ${WORK_DIR}
cd ${WORK_DIR}
rm -rf rel
mkdir rel

echo "Set up application version 1 and generate release..."
${REBAR} create-app appid=sample
${REBAR} compile

cd rel
${REBAR} create-node nodeid=sample
cp ${BASE_DIR}/reltool.config.v1 ./reltool.config
${REBAR} generate
mv sample sample_1

echo "Change version to 2 and generate release again..."
cd ${WORK_DIR}
cp src/sample.app.src sample.app.src.v1
cp ${BASE_DIR}/sample.app.src.v2 src/sample.app.src
cp ${BASE_DIR}/sample_app.erl.v2 src/sample_app.erl
(diff -U 2 sample.app.src.v1 src/sample.app.src; true)
${REBAR} clean
${REBAR} compile
cd rel
cp reltool.config reltool.config.v1
cp ${BASE_DIR}/reltool.config.v2 ./reltool.config
(diff -U 2 reltool.config.v1 reltool.config; true)
${REBAR} generate

echo "Generate appup and upgrade..."
${REBAR} generate-appups previous_release=sample_1
${REBAR} generate-upgrade previous_release=sample_1

echo "Try to stop the node in case it is alive..."
(${WORK_DIR}/rel/sample_1/bin/sample stop ; true)

echo "Start erlang node with rel version 1..."
cd ${BASE_DIR}
${WORK_DIR}/rel/sample_1/bin/sample start

epmd -names

echo "Finished."
