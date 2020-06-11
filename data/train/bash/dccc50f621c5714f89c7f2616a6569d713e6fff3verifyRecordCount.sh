#!/bin/bash
# Copyright (c) 2012 Yahoo! Inc. All rights reserved.
# Copyrights licensed under the New BSD License. See the accompanying LICENSE file for terms.
#

log_status () {
	echo "reporter:status:$*" >&2
}

FILE="$1"
COUNT=count.dat

rm -f $COUNT
for each in chunk-*$FILE
do
	log_status "Verify Processing chunk ... $each"
	bunzip2 -c $each | wc -l >> $COUNT
done

CHUNK_RECORDS=`cat $COUNT | xargs | tr " " "+" | bc -l`
rm -f $COUNT

log_status "Chunk records - $CHUNK_RECORDS, Calculating $FILE records"

FILE_RECORDS=`bunzip2 -c $FILE | wc -l`
if [ $CHUNK_RECORDS -eq $FILE_RECORDS ]
then
	log_status "SUCCESS: Records match - $FILE - File ($FILE_RECORDS), chunks ($CHUNK_RECORDS)"
else
	log_status "FAILED: Records DONT match - $FILE - File ($FILE_RECORDS), chunks ($CHUNK_RECORDS)"
	exit 1
fi
