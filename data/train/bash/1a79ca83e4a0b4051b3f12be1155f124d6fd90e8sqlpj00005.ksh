#!/bin/sh
#sqlpj00005 - create all database tables in new derby instance

TESTNAME=sqlpj00005
echo TESTNAME is $TESTNAME
. ./regress_defs.ksh

SQLOUT=$TEST_ROOT/create_tables.out

cp -r $REGRESS_SRCROOT/scripts/toursdb $TEST_ROOT

# scripts/toursdb/loadAIRLINES.sql
# scripts/toursdb/loadCOUNTRIES.sql
# scripts/toursdb/loadFLIGHTAVAILABILITY1.sql
# scripts/toursdb/loadFLIGHTAVAILABILITY2.sql
# scripts/toursdb/loadFLIGHTS1.sql
# scripts/toursdb/loadFLIGHTS2.sql
# scripts/toursdb/loadTables.sql
# scripts/toursdb/ToursDB_schema.sql


cd "$TEST_ROOT"
sqlpj -props "$REGRESS_TESTDB_PROPS" -prompt "" toursdb/ToursDB_schema.sql > $SQLOUT
echo sqlpj status is $?
cat $SQLOUT
