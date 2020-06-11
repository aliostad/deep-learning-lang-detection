#!/bin/sh
#	INFO
#	to reformat the input bams to make it work with TREAT workflow

if [ $# != 4 ];
then
	echo "Usage : <sample><output><bam><run_info>";
else
	set -x
	echo `date`
	sample=$1
	output=$2
	bam=$3
	run_info=$4
	input=$( cat $run_info | grep -w '^INPUT_DIR' | cut -d '=' -f2)
	tool_info=$( cat $run_info | grep -w '^TOOL_INFO' | cut -d '=' -f2)
	samtools=$( cat $tool_info | grep -w '^SAMTOOLS' | cut -d '=' -f2)
	script_path=$( cat $tool_info | grep -w '^TREAT_PATH' | cut -d '=' -f2 )
	ref=$( cat $tool_info | grep -w '^REF_GENOME' | cut -d '=' -f2 )
	center=$( cat $run_info | grep -w '^CENTER' | cut -d '=' -f2 )
	platform=$( cat $run_info | grep -w '^PLATFORM' | cut -d '=' -f2 )
	GenomeBuild=$( cat $run_info | grep -w '^GENOMEBUILD' | cut -d '=' -f2 )
	Aligner=$( cat $run_info | grep -w '^ALIGNER' | cut -d '=' -f2 )
	Aligner=`echo "$Aligner" | tr "[a-z]" "[A-Z]"`
	picard=$( cat $tool_info | grep -w '^PICARD' | cut -d '=' -f2 ) 
	java=$( cat $tool_info | grep -w '^JAVA' | cut -d '=' -f2)
	dup=$( cat $run_info | grep -w '^MARKDUP' | cut -d '=' -f2)
	dup=`echo "$dup" | tr "[a-z]" "[A-Z]"`
	output_sample=$output/$sample
	## check if BAM is sorted
	SORT_FLAG=`perl $script_path/checkBAMsorted.pl -i $input/$bam -s $samtools`
	if [ $SORT_FLAG == 1 ]
	then
		ln -s $input/$bam $output_sample/$sample-sorted.bam
	else
		$java/java -Xmx6g -Xms512m \
		-jar $picard/SortSam.jar \
		INPUT=$input/$bam \
		OUTPUT=$output_sample/$sample-sorted.bam \
		SO=coordinate \
		TMP_DIR=$output_sample/ \
		VALIDATION_STRINGENCY=SILENT
	fi
	## check if read group and platform is availbale in BAM
	RG_FLAG=`perl $script_path/checkBAMreadGroup.pl -i $output_sample/$sample-sorted.bam -s $samtools`
	if [ $RG_FLAG == 0 ]
	then
		$java/java -Xmx6g -Xms512m \
		-jar $picard/AddOrReplaceReadGroups.jar \
		INPUT=$output_sample/$sample-sorted.bam
		OUTPUT=$output_sample/$sample-sorted.rg.bam
		PL=$platform \
		SM=$sample \
		CN=$center \
		ID=$sample \
		PU=$sample \
		LB=$GenomeBuild \
		TMP_DIR=$output_sample/ \
		VALIDATION_STRINGENCY=SILENT
	fi	
	$samtools/samtools flagstat $output_sample/$sample-sorted.bam > $output_sample/$sample.flagstat
	cat $output_sample/$sample.flagstat | grep -w mapped | cut -d ' ' -f1 > $output_sample/$sample.mapped
	## remove duplicates 
	if [ $dup == "YES" ]
	then
	#	$samtools/samtools rmdup $input/$sample-sorted.bam $input/$sample-sorted.rmdup.bam
		$java/java -Xmx6g -Xms512m \
		-jar $picard/MarkDuplicates.jar \
		INPUT=$output_sample/$sample-sorted.bam \
		OUTPUT=$output_sample/$sample-sorted.rmdup.bam \
		METRICS_FILE=$output_sample/$sample.dup.txt \
		REMOVE_DUPLICATES=true \
		VALIDATION_STRINGENCY=SILENT \
		TMP_DIR=$output_sample/
		mv $output_sample/$sample-sorted.rmdup.bam $output_sample/$sample-sorted.bam
 	fi	
	$samtools/samtools index $output_sample/$sample-sorted.bam
	## geting number for q 20 quality
	$samtools/samtools view -b -q 20 $output_sample/$sample-sorted.bam > $output_sample/$sample-sorted.q20.bam
	$samtools/samtools index $output_sample/$sample-sorted.q20.bam
	$samtools/samtools flagstat $output_sample/$sample-sorted.q20.bam > $output_sample/$sample.q20.flagstat
	cat $output_sample/$sample.q20.flagstat | grep -w mapped | cut -d ' ' -f1 > $output_sample/$sample.q20.mapped
	rm $output_sample/$sample-sorted.q20.bam
	rm $output_sample/$sample-sorted.q20.bam.bai
	echo `date`
fi	
			
			