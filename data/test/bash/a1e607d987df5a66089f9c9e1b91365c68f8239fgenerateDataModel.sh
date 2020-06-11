#!/bin/sh

DATA_MODEL_FILE="$PROJECT_DIR/App/Model/CoreDataModel/Model.xcdatamodeld/Model.xcdatamodel"
DATA_MODEL_SOURCE_DIR="$PROJECT_DIR/App/Model/ModelObjects/Human"
DATA_MODEL_SOURCE_MACHINE_DIR="$PROJECT_DIR/App/Model/ModelObjects/Machine"
MOGENERATOR="mogeneratorswift"

MOGENERATOR_TEMPLATES="$PROJECT_DIR/App/Model/CoreDataModel/MogenTemplate"
MOGENERATOR_BIN="$MOGENERATOR_TEMPLATES/$MOGENERATOR"

GENERATE_DATE=`date "+%d\\/%m\\/%y"`
GENERATE_YEAR=`date "+%Y"`
USER_NAME=`osascript -e "long user name of (system info)"`

#type -P $MOGENERATOR &>/dev/null || { echo "This script requires $MOGENERATOR from https://github.com/rentzsch/mogenerator.  Please install it and run again." >&2; exit 1; }

if [ ! -f "$MOGENERATOR_BIN" ] 
then
	MOGENERATOR_BIN=`type -P $MOGENERATOR`
	if [ ! -f "$MOGENERATOR_BIN" ]
	then
		echo "mogenerator binary doesn't exist at $MOGENERATOR_BIN"
		exit 1
	fi
fi

echo "Generating Data Model Classes from $DATA_MODEL_FILE ..."
if [ ! -d "$DATA_MODEL_FILE" ] 
	then
	echo "Data model file doesn't exist at $DATA_MODEL_FILE"
exit 1
fi

mkdir -p "$DATA_MODEL_SOURCE_DIR"

MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS=YES \
MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR=YES \
"$MOGENERATOR_BIN" \
-m "$DATA_MODEL_FILE" \
-M "$DATA_MODEL_SOURCE_MACHINE_DIR" \
-H "$DATA_MODEL_SOURCE_DIR" \
--template-path ./MogenTemplate \
--template-var arc=true || exit 1

echo "Generated Data Model Classes to $DATA_MODEL_SOURCE_DIR"
