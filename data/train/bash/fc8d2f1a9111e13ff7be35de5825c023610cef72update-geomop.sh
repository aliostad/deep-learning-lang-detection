#!/bin/bash
GEOMOP_DIR=$1

if [ -z $GEOMOP_DIR ]
then
    GEOMOP_DIR=~/workspace/GeoMop
fi

find "${GEOMOP_DIR}" -name '*.pyc' -delete
find "${GEOMOP_DIR}" -name '__pycache__' -delete

for f in ./common ModelEditor/data ModelEditor/dialogs ModelEditor/helpers ModelEditor/ist ModelEditor/meconfig ModelEditor/panels ModelEditor/util ModelEditor/resources/css ModelEditor/resources/format ModelEditor/resources/transformation ModelEditor/*.py
do
	eval cp -r "${GEOMOP_DIR}/src/$f" "./src/python/GeoMop/${f%/*}"
done
