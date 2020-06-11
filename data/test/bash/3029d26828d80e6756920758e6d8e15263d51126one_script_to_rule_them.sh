#!/bin/bash
#
# a wrapper script to wrangle the rest into proper sequence
#
# http://confluence.sakaiproject.org/display/SAKDEV/Sakai+3+Load+Testing
#
# drive preconfiguration
#
#
echo "testing your environment for required programs" 
# ignoring jmeter custom install issues for the moment

for NEED in ruby perl curl awk
do
  type -P $NEED &>/dev/null   || { echo "can't find $NEED"  >&2; 
                                   ERRORS=1; }
done


if [[ $ERRORS > 0 ]]
then
 echo "Fatal environment setup errors, exiting ${ERRORS}"
 exit 1
fi

HERE=`pwd`

echo "prepare load files"
. prepare-load-files.sh

echo "prepare content via prepare-data.sh"
. prepare-data.sh 10 ${HERE}/TestContent

echo "load data via load-data.sh"
. load-data.sh localhost 8080

echo "completed, ready to run load tests."

