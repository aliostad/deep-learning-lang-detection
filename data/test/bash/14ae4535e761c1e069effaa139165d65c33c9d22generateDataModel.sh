#!/bin/sh

DATA_MODEL_FILE="$PROJECT_DIR/App/Model/CoreDataModel/Model.xcdatamodeld/Model.xcdatamodel"
DATA_MODEL_SOURCE_DIR="$PROJECT_DIR/App/Model/ModelObjects/Human"
DATA_MODEL_SOURCE_MACHINE_DIR="$PROJECT_DIR/App/Model/ModelObjects/Machine"
BASE_CLASS="ModelObject"
AGGREGATE_HEADER="$PROJECT_DIR/App/Model/ModelObjectHeaders.h"
AGGREGATE_HEADER_FORWARD_CLASSES="$PROJECT_DIR/App/Model/ModelObjectClasses.h"
MOGENERATOR="mogenerator"

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
mkdir -p "$DATA_MODEL_SOURCE_MACHINE_DIR"

MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS=YES \
MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR=YES \
"$MOGENERATOR_BIN" \
-m "$DATA_MODEL_FILE" \
-M "$DATA_MODEL_SOURCE_MACHINE_DIR" \
-H "$DATA_MODEL_SOURCE_DIR" \
--includeh "$AGGREGATE_HEADER" \
--template-path ./MogenTemplate \
--template-var arc=true || exit 1

find $DATA_MODEL_SOURCE_DIR -not \( -type d -name ".?*" -prune \) \( -name "*.h" -o -name "*.m" \) -type f -print0 | xargs -0 sed -e "s/<#ProjectName#>/$PROJECT_NAME/g" -e "s/<#ModelAuthor#>/$USER_NAME/g" -e "s/<#GenerateDate#>/$GENERATE_DATE/g" -e "s/<#GenerateYear#>/$GENERATE_YEAR/g" -i ""
sed -e 's/.*\"\([A-Za-z0-9]*\)\.h\".*/@class \1\;/g' $AGGREGATE_HEADER > $AGGREGATE_HEADER_FORWARD_CLASSES

echo "Generated Data Model Classes to $DATA_MODEL_SOURCE_DIR"
