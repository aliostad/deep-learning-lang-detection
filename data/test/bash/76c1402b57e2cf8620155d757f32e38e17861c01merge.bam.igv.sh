#!/bin/sh

##	INFO
### The script is used to merge all the realigned cleaned bam files per sample

######################################
#	$1		=		Output Directory
#	$2		=		Output realignment folder 
#	$3		=		Sample Name
#	$4		=		run ifno file
#########################################

if [ $# != 4 ];
then
	echo "Usage: <output dir> <output realignemnt dir><sample name> <run info file> ";
else			
	set -x
	echo `date`
	output_dir=$1 
	output_realign=$2 
	sample=$3
	run_info=$4
	tool_info=$( cat $run_info | grep -w '^TOOL_INFO' | cut -d '=' -f2)
	script_path=$( cat $tool_info | grep -w '^TREAT_PATH' | cut -d '=' -f2)
	samtools=$( cat $tool_info | grep -w '^SAMTOOLS' | cut -d '=' -f2 )
	ref_path=$( cat $tool_info | grep -w '^REF_GENOME' | cut -d '=' -f2)
	##Folder Structure
	mkdir $output_dir/realigned_data/$sample
	output_sample=$output_dir/realigned_data/$sample
	cd $output_realign/$sample
	touch header.sam
	for i in *.bam
	do
		$samtools/samtools view -H $i > header.sam
	done
	$samtools/samtools merge -h $output_realign/$sample/header.sam $output_sample/$sample.igv.bam $output_realign/$sample/*.cleaned-sorted.bam  
	$samtools/samtools sort -m 800000000 $output_sample/$sample.igv.bam $output_sample/$sample.igv-sorted
	rm $output_sample/$sample.igv.bam
	$samtools/samtools index $output_sample/$sample.igv-sorted.bam
	echo `date`
fi	