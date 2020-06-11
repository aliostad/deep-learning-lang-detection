#!/bin/sh
#	INFO	
#	to merge all the bam files if the samples are run on multiple lanes

###################################
#		$1		=		sample directory
#		$2		=		sample name
#		$3		=		run-info file
###################################

if [ $# != 3 ];
then
	echo "Usage: <sample dir><sample><run_info>";
else	
	set -x
	echo `date`
	output_dir_sample=$1
	sample=$2
	run_info=$3
	tool_info=$( cat $run_info | grep -w '^TOOL_INFO' | cut -d '=' -f2)
	samtools=$( cat $tool_info | grep -w '^SAMTOOLS' | cut -d '=' -f2)
	ref=$( cat $tool_info | grep -w '^REF_GENOME' | cut -d '=' -f2)
	script_path=$( cat $tool_info | grep -w '^TREAT_PATH' | cut -d '=' -f2 )
	java=$( cat $tool_info | grep -w '^JAVA' | cut -d '=' -f2)
	dup=$( cat $run_info | grep -w '^MARKDUP' | cut -d '=' -f2)
	dup=`echo "$dup" | tr "[a-z]" "[A-Z]"`
	picard=$( cat $tool_info | grep -w '^PICARD' | cut -d '=' -f2 ) 
	cd $output_dir_sample
	touch header.sam
	for i in *.bam
	do
		$samtools/samtools view -H $i > header.sam
	done
	$samtools/samtools merge -h header.sam $sample *.bam
	rm *.bam
	rm header.sam
	mv $sample $sample.bam
	#$samtools/samtools sort -m 800000000 $sample.bam $sample-sorted
	$java/java -Xmx6g -Xms512m \
	-jar $picard/SortSam.jar\
	INPUT=$sample.bam \
	OUTPUT=$sample-sorted.bam \
	SO=coordinate \
	TMP_DIR=$output_dir_sample/ \
	VALIDATION_STRINGENCY=SILENT
	rm $sample.bam
	$samtools/samtools flagstat $sample-sorted.bam > $sample.flagstat
	cat $sample.flagstat| grep -w mapped | cut -d ' ' -f1 > $sample.mapped
	## remove duplicates 
	if [ $dup == "YES" ]
	then
	#	$samtools/samtools rmdup $sample-sorted.bam $sample-sorted.rmdup.bam
		$java/java -Xmx6g -Xms512m \
		-jar $picard/MarkDuplicates.jar \
		INPUT=$sample-sorted.bam \
		OUTPUT=$sample-sorted.rmdup.bam \
		METRICS_FILE=$sample.dup.txt \
		REMOVE_DUPLICATES=true \
		VALIDATION_STRINGENCY=SILENT \
		TMP_DIR=$output_dir_sample/
		mv $sample-sorted.rmdup.bam $sample-sorted.bam
 	fi	
	$samtools/samtools index $sample-sorted.bam
	## getting the numbers for mapped reads with min quality 20
	$samtools/samtools view -b -q 20 $sample-sorted.bam > $sample-sorted.q20.bam
	$samtools/samtools index $sample-sorted.q20.bam
	$samtools/samtools flagstat $sample-sorted.q20.bam > $sample.q20.flagstat
	cat $sample.q20.flagstat | grep -w mapped | cut -d ' ' -f1 > $sample.q20.mapped
	rm $sample-sorted.q20.bam
	rm $sample-sorted.q20.bam.bai
	echo `date`
fi	
