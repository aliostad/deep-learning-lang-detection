#!/bin/bash

# change testname from 'sample' to your testname.
# testname should contain only word caractors.
[ $# -eq 0 ] && echo "you must give new testname" && exit 1
TESTNAME=$1
echo $TESTNAME | grep "\W" > /dev/null && echo "invalid name format" && exit 1
! grep sample run-test.sh > /dev/null && echo "Already renamed" && exit 1

echo "change testname to $TESTNAME"
ruby -i -ne "puts \$_.gsub(/sample/, \"${TESTNAME}\")" run-test.sh
ruby -i -ne "puts \$_.gsub(/sample/, \"${TESTNAME}\")" lib/Makefile
ruby -i -ne "puts \$_.gsub(/sample/, \"${TESTNAME}\")" lib/setup_sample_test.sh
mv lib/sample.c lib/${TESTNAME}.c
mv lib/setup_sample_tools.sh lib/setup_${TESTNAME}_test.sh
mv lib/setup_sample_test.sh lib/setup_${TESTNAME}_test.sh
