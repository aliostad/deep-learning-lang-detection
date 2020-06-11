#!/bin/bash

trap 'echo "$0:$LINENO \"$BASH_COMMAND\"" ; exit 1' ERR

BASE_DIR=`pwd`
WORK_DIR=${BASE_DIR}/sample
NODETOOL=${WORK_DIR}/rel/sample_1/releases/1/nodetool
NODETOOL_ARGS_RPC="-name sample@127.0.0.1 -setcookie sample rpcterms"
cd ${WORK_DIR}/rel

echo "Confirm only version 1 is installed..."
${NODETOOL} ${NODETOOL_ARGS_RPC} release_handler which_releases ''
echo "Call the function which WILL be added in version 2, 'undef' should be thrown..."
(${NODETOOL} ${NODETOOL_ARGS_RPC} sample_app new_export '' ; true)

echo "Unpack new version manually..."
mkdir -p sample-relup12
tar zxf sample_2.tar.gz -C sample-relup12
# Copy all files under node release directory
cp -a sample-relup12/releases sample_1/
# Copy only sample application version 2 under lib
# because relup has all necessary applications including OTP's ones.
cp -a sample-relup12/lib/sample-2 sample_1/lib/

echo "Execute 'release_handler:set_unpacked/1' manually..."
# release_handler:set_unpacked("releases/sample_2.rel", [{sample, "2", "lib"}])
${NODETOOL} ${NODETOOL_ARGS_RPC} release_handler set_unpacked \
    '"releases/sample_2.rel". [{sample, "2", "lib"}]. '

echo "Execute 'release_handler:install_release("2")..."
${NODETOOL} ${NODETOOL_ARGS_RPC} release_handler install_release '"2". '

echo "Execute the function which have added in version 2..."
${NODETOOL} ${NODETOOL_ARGS_RPC} sample_app new_export ''

echo "Make version 2 permanent..."
${NODETOOL} ${NODETOOL_ARGS_RPC} release_handler make_permanent '"2". '

echo "Confirm version 2 is installed..."
${NODETOOL} ${NODETOOL_ARGS_RPC} release_handler which_releases ''

echo "Finished."

