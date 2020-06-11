#!/bin/sh

#
# This file is released under the terms of the Artistic License.
# Please see # the file LICENSE, included in this package, for details.
#
# Copyright (C) 2002 Mark Wong & Open Source Development Lab, Inc.
#

DIR=`dirname $0`
BACKGROUND=no
. ${DIR}/pgsql_profile || exit 1

while getopts "bd:t" OPT; do
	case ${OPT} in
	b)
		BACKGROUND=yes
		;;
	d)
		DBDATA=${OPTARG}
		;;
	t)
		TABLESPACES_FLAG="-t"
		;;
	esac
done

# Load tables
# This background stuff is honestly kinda ugly. IMO the right way to do this is to utilize make -j
load_table() {
	table=$1
	if [ x$2 == x ]; then
		file=$table.data
	else
		file=$2.data
	fi

	local sql="COPY $table FROM '${DBDATA}/$file' WITH NULL AS '';"
	local cmd="${PSQL} -e -d ${DBNAME} -c "
	if [ $BACKGROUND == yes ]; then
		echo "Loading $table table in the background..."
		${cmd} "${sql} VACUUM ANALYZE $table;" || exit 1 &
	else
		echo "Loading $table table..."
		${cmd} "${sql}" || exit 1
	fi
}

load_table customer
load_table district
load_table history
load_table item
load_table new_order
load_table order_line
load_table orders order
load_table stock
load_table warehouse

wait

./create_indexes.sh ${TABLESPACES_FLAG} || exit 1

# load C or SQL implementation of the stored procedures
if true; then
  ./load_stored_funcs.sh || exit 1
else
  ./load_stored_procs.sh || exit 1
fi

${PSQL} -e -d ${DBNAME} -c "SELECT setseed(0);" || exit 1

# VACUUM FULL ANALYZE: Build optimizer statistics for newly-created
# tables. The VACUUM FULL is probably unnecessary; we want to scan the
# heap and update the commit-hint bits on each new tuple, but a regular
# VACUUM ought to suffice for that.

if [ $BACKGROUND == no ]; then
    $VACUUMDB -z -f -d ${DBNAME} || exit 1
fi

exit 0
