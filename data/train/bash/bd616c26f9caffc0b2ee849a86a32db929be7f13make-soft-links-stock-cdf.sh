#!/bin/bash

if [ $# != 2 ] ; then
	echo "
Usage: 

./make-soft-links.sh [Parameters]

Parameters:
<source_dir>
<dest_dir>
"
	exit 1
fi

source=$1
dest=$2
current=`pwd`

mkdir $dest

for i in $source/* ; do
	SAMPLE=`basename $i`
	mkdir $current/$dest/$SAMPLE/
	#ln -s $current/$source/$SAMPLE/*.mmseq $current/$dest/$SAMPLE/
	ln -s $current/$source/$SAMPLE/accepted_hits.RData $current/$dest/$SAMPLE/
	#ln -s $current/$source/$SAMPLE/tophat $current/$dest/$SAMPLE/
	#ln -s $current/$source/$SAMPLE/*.fa* $current/$dest/$SAMPLE/
	#ln -s $current/$source/$SAMPLE/*.sra $current/$dest/$SAMPLE/
done
