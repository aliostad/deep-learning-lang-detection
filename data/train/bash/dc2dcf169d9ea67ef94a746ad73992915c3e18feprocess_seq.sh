#!/bin/bash
#
#2015-10-20 11:28
#<nicksimon109445@gmail.com>
#process the format of rss sample
#
sample_file="seq_alice"
sample_final="seq_final"
if [ -e $sample_final ]; then
	echo "file exists"
	rm $sample_final
fi
read -p "The name of the sample file,default is $sample_file:" input
sample_file=${input:-$sample_file}
outfile="seq_tmp"
awk -F ":" -v out=$outfile -f seq_process.awk $sample_file
#rm $outfile
if [ ! -f $outfile ]; then
	echo "flie does not exists"	
	exit -1
fi
#cat $outfile | sed -n -e 's/-\([0-9]+\)dm/\1/'
cat $outfile | sed -n -e 's/-\([0-9]\{1,\}\)dm/\1/p' >> $sample_final
rm $outfile
