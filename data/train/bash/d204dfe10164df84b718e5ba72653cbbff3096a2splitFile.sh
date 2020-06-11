#!/bin/bash
# Copyright (c) 2012 Yahoo! Inc. All rights reserved.
# Copyrights licensed under the New BSD License. See the accompanying LICENSE file for terms.
#

while read items
do
	ls >&2
	INPUTFILE=`echo $items | cut -d: -f1 | awk '{print $2}'`
	OUTPUTFILE=`echo $items | cut -d: -f2`

	echo "Processing files - $INPUTFILE - $OUTPUTFILE" >&2
	$HADOOP_HOME/bin/hadoop fs -get $INPUTFILE .
	FILE=`basename $INPUTFILE`
	./splitBzip2.sh "$FILE"
	$HADOOP_HOME/bin/hadoop fs -put chunk-* $OUTPUTFILE
	rm -f chunk-* $FILE
done
