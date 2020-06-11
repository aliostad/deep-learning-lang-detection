#!/bin/bash -l

if [ $# -ne 3 ]; then
  	echo "
To be run from the analysis directory

Usage:
	RNA_analysis_delivery.sh <uppnex_id> <project id> <Dry run, y/n>
"
  	exit
else

uppnex_id=$1
project_id=$2
deliv_path=/proj/$uppnex_id/INBOX/$project_id
sample_list=`for dir in tophat_out_*; do echo ${dir##*out_};done|sort -n`

echo "
Will create directories:"
echo "$deliv_path/analysis"
echo "$deliv_path/analysis/quantification"
echo "$deliv_path/analysis/alignments
"
echo "will try to copy:"
for sample in $sample_list ;do  
echo "tophat_out_$sample/accepted_hits_$sample.bam"
echo "tophat_out_$sample/accepted_hits_sorted_dupRemoved_$sample.bam";done
echo "to $deliv_path/analysis/alignments

will try to copy:
_build/latex/${project_id}_analysis.pdf
to $deliv_path/analysis

will try to copy:
count_table.txt 
fpkm_table.txt"
for sample in $sample_list ;do	echo "tophat_out_$sample/cufflinks_out_$sample"; done
echo "to $deliv_path/analysis/quantification
"

if [ $3 = "y" ]; then exit; fi

fi

logfile=/bubo/home/h27/funk_001/log/RNA_delivery_log/`date +%F_%T|sed -e 's/-//g'`.log

mkdir $deliv_path/analysis 2>$logfile
mkdir $deliv_path/analysis/quantification 2>>$logfile
mkdir $deliv_path/analysis/alignments 2>>$logfile

cp count_table.txt fpkm_table.txt $deliv_path/analysis/quantification 2>>$logfile
cp _build/latex/${project_id}_analysis.pdf $deliv_path/analysis 2>>$logfile


for sample in $sample_list ;do
	echo "copying from sample $sample"
	cp -r tophat_out_$sample/cufflinks_out_$sample $deliv_path/analysis/quantification 2>>$logfile
	cp tophat_out_$sample/accepted_hits_$sample.bam $deliv_path/analysis/alignments 2>>$logfile
	cp tophat_out_$sample/accepted_hits_sorted_dupRemoved_$sample.bam $deliv_path/analysis/alignments 2>>$logfile

done

cat $logfile

