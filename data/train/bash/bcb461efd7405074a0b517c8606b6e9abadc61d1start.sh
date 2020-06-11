#!/bin/bash

EXEC_BIN="/factorio/bin/x64/factorio"
SAVE_DIR="/factorio/saves"
WORLD="${SAVE_DIR}/world.zip"

LAST_SAVE=`ls -t ${SAVE_DIR}/*.zip 2> /dev/null | head -1`

echo "# Latest autosave file: ${LAST_SAVE}"

# Check save map
if [ ! ${LAST_SAVE} ]; then
    echo "# create world: ${WORLD}"
    ${EXEC_BIN} --create ${WORLD}
else
    if [ ${LAST_SAVE} != ${WORLD} ]; then
        echo "# mv world file: ${WORLD}"
        mv ${LAST_SAVE} ${WORLD}
    fi
fi

# Run server with args
${EXEC_BIN} --start-server ${WORLD} --server-settings /factorio/data/server-settings.json $@
