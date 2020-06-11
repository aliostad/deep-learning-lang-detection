#!/bin/bash
# 
# export_load_test.sh
# 
# -------------------------------------------------------------------------------
# 
#================================================================================
echo
#================================================================================
#
# printUsage()
# 
# Prints out usage instructions for this script.
#
#================================================================================
function printUsage() {

	echo
	echo "USAGE:  "
	echo
	echo "    $ $SCRIPTNAME < -p < PROFILE > | -g < GROUP_NAME > >  [ -r < REGION > [ -d ]] [ -c ] [ -i ]"
	echo 
	echo "        -c - Use the rules for Collectors and Agents."
}
#===============================================================================
#	Start of script.
#===============================================================================

INVOKEPATH=`echo $0 | awk -F'/[^/]*.sh$' '{ print $1 }'` 
SCRIPTNAME=`echo $0 | awk -F'/' '{ print $NF }'`
CURRENT_DIR=`pwd -P`

JDBC_HOST="localhost"
JDBC_USER="wmuser"
JDBC_PASSWORD="wmuser"
JDBC_DATABASE="load_testing"

LOAD_TEST_ID=35583
SELECT_STMT="select load_test_id from load_test where load_test_id = $LOAD_TEST_ID or parent_load_test_id = $LOAD_TEST_ID"

echo $SELECT_STMT
echo

IDS=()

IDS=($(mysql -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	-e "select load_test_id from load_test where load_test_id = $LOAD_TEST_ID or parent_load_test_id = $LOAD_TEST_ID" --xml \
	| grep "field" \
	| awk -F\> '{print $2}' \
	| awk -F\< '{print $1}'))

echo "IDS = ${IDS[@]}"

exit
echo "mysqldump -t -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	--skip-add-drop-table --single-transaction --quick --lock-tables=false \
	--tables load_test --where='load_test_id = 35583 or parent_load_test_id = 35583'"

#  load_test
mysqldump -t -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	--skip-add-drop-table --single-transaction --quick --lock-tables=false \
	--tables load_test --where='load_test_id = 35583 or parent_load_test_id = 35583'

exit

#  load_test_part
mysqldump -t -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	--skip-add-drop-table --single-transaction --quick --lock-tables=false \
	--tables load_test_part --where='load_test_id = 35583 and parent_load_test_id = 35583'

#  load_test_region
mysqldump -t -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	--skip-add-drop-table --single-transaction --quick --lock-tables=false \
	--tables load_test_region --where='load_test_id = 35583 and parent_load_test_id = 35583'

#  load_test_script
mysqldump -t -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	--skip-add-drop-table --single-transaction --quick --lock-tables=false \
	--tables load_test_script --where='load_test_id = 35583 and parent_load_test_id = 35583'

#  load_test_failure
mysqldump -t -h $JDBC_HOST -u $JDBC_USER -p$JDBC_PASSWORD $JDBC_DATABASE \
	--skip-add-drop-table --single-transaction --quick --lock-tables=false \
	--tables load_test_failure --where='load_test_id = 35583 and parent_load_test_id = 35583'
