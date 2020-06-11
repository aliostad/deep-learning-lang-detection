#!/bin/bash     
# run the 10 construct queries and get the amount of tripes after each query
JAR=$1
CONSTRUCT_FILES=$2
CURRENT_PATH=$(pwd)
FILES=$CURRENT_PATH"/"$CONSTRUCT_FILES
INPUT_REPO=$3
OUTPUT_REPO=$4

##### DEBUG #####
#echo "$JAR"
#echo "$CONSTRUCT_FILES"
#echo "$INPUT_REPO"
#echo "$OUTPUT_REPO"
########3


rm -r $OUTPUT_REPO 

cd $CONSTRUCT_FILES

for FILE in $(ls $CONSTRUCT_FILES)
do
    if [[ -n $VERBOSE ]]; then
        echo "construct "$FILE
        java $JAVA_ARGS -jar $JAR --verbose --construct $FILE --input-repo $INPUT_REPO $OUTPUT_REPO | egrep "^(Triples|Queries)"
        java $JAVA_ARGS -jar $JAR --query "select (count(*) as ?count) where {?a ?c ?b}" $OUTPUT_REPO | egrep -o "^\"[0-9]+\""| egrep -o "[0-9]+" 
    else
        java $JAVA_ARGS -jar $JAR  --construct $FILE --input-repo $INPUT_REPO $OUTPUT_REPO > /dev/null
    fi

done
