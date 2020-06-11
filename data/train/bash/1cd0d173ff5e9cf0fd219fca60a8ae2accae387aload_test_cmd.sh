#!/bin/sh

# DEPRECATED!!! Please build the command line package and use load_lsf.sh instead


# Used for load_test_lsf.sh
#

MYDIR=$(dirname "$0")
cd "$MYDIR"/..

fpath="$1"
outfpath="$2"

pid=$$

mvn exec:java \
  -offline \
  -Ptest.oracle_test \
	-DargLine="-Xms1G -Xmx4G -XX:PermSize=256m -XX:MaxPermSize=2G" \
	-Dexec.classpathScope=test \
	-Dexec.mainClass=uk.ac.ebi.fg.biosd.sampletab.test.LoadTestCmd \
	-Dexec.args="$fpath $pid" 
		  
. target/biosd.loadTest_out_$$.sh
rm -f target/biosd.loadTest_out_$$.sh

printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$fpath" "$BIOSD_LOAD_RESULT_EXCEPTION" "$BIOSD_LOAD_RESULT_MESSAGE" "$N_ITEMS" \
       "$PARSING_TIME" "$PERSISTENCE_TIME" >>$outfpath
