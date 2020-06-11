#!/bin/bash

## script to run GATK

#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=#threads:mem=#memorygb:tmpspace=#tmpSpacegb

#PBS -M igf@imperial.ac.uk
#PBS -m ea
#PBS -j oe

#PBS -q pqcgi

NOW="date +%Y-%m-%d%t%T%t"

JAVA_XMX=4G

module load gatk/#gatkVersion
module load java/#javaVersion

INPUT_GVCF_SCRATCH=#inputGVCF
REFERENCE_CHUNKS=#chunkBed
OUTPUT_DIR=#outputDir
RUN_DIR=#runDir
SUBSET=#subset
SAMPLE=#sample
REFERENCE_FASTA=#referenceFasta


#input_gvcf_name=`basename $INPUT_GVCF_SCRATCH .gz`
#input_gvcf_name=`basename $input_gvcf_name .genomic.vcf`

input_gvcf_name=`basename $INPUT_GVCF_SCRATCH .genomic.vcf`
input_gvcf=$TMPDIR/$input_gvcf_name.genomic.vcf
#input_gvcf=$TMPDIR/$input_gvcf_name.genomic.vcf.gz

#FUNCTIONS
####################################

function checkStatus {

	PROCESS_COUNT=0;
	for PID in $PROCESS_IDS
	do
    	PROCESS_COUNT=$(($PROCESS_COUNT+1))
	done;

	while [ $PROCESS_COUNT -gt 0 ]
	do
	
		echo "`${NOW}`INFO $SCRIPT_CODE checking child processes..."
	
    	for PID in $PROCESS_IDS
    	do
		if kill -0 $PID
		then
	    	echo "`${NOW}`INFO $SCRIPT_CODE $PID still alive"
		else
	    	echo "`${NOW}`INFO $SCRIPT_CODE $PID has finished"
	    	PROCESS_IDS=`echo $PROCESS_IDS | perl -pe "s/$PID//"`
	    	PROCESS_COUNT=$(($PROCESS_COUNT-1))
		fi
    	done
    
    	sleep 60

	done

}

#MAIN
############

echo "`${NOW}`INFO $SCRIPT_CODE copying reference to tmp directory..."
cp $REFERENCE_FASTA $TMPDIR/reference.fa
cp $REFERENCE_FASTA.fai $TMPDIR/reference.fa.fai
REFRENCE_SEQ_DICT=`echo $REFERENCE_FASTA | perl -pe 's/\.fa/\.dict/'`
cp $REFRENCE_SEQ_DICT $TMPDIR/reference.dict

echo "`${NOW}`INFO copying input GVCF file and index to $TMPDIR..." 
cp $INPUT_GVCF_SCRATCH $input_gvcf
#gunzip $input_gvcf
#input_gvcf=`basename $input_gvcf .gz`
cp $INPUT_GVCF_SCRATCH.idx $input_gvcf.idx
echo "`${NOW}`INFO done"

analysis_dir=$TMPDIR
mkdir $analysis_dir/chunks


#get chunk count
TOTAL_CHUNK_COUNT=0

for CHUNK_NAME in `cut -f 5 $REFERENCE_CHUNKS | sort -n | uniq`
do
	
	if [[ $CHUNK_NAME != ""  ]]
	then
		TOTAL_CHUNK_COUNT=$(( $TOTAL_CHUNK_COUNT + 1 ))
	fi
	
done;

echo "`${NOW}`INFO starting chunk extraction..."
PROCESS_IDS=""
for chunk_name in `cut -f 5 $REFERENCE_CHUNKS | sort -n | uniq`; do

	if [[ $chunk_name != ""  ]]; then 

		chunk_count=$(( $chunk_count + 1 ))
			
		includes_unmapped=F	

		echo "`${NOW}`INFO $SCRIPT_CODE chunk $chunk_count of $TOTAL_CHUNK_COUNT..."
				
		chunk="chunk_$chunk_name"

		chunk_int=$analysis_dir/chunks/$chunk.intervals
		chunk_bed=$analysis_dir/chunks/$chunk.bed

		echo "`${NOW}`INFO $SCRIPT_CODE creating chunk interval file..."
		#converting BED to interval list skipping blank lines
		#converting to chr:start-end format instead of tab delimited
		#format as GATK started to refuse parsing tab delimited format for some
		#reason
		grep -P "chunk_${chunk_name}\." $REFERENCE_CHUNKS | awk '/^\s*$/ {next;} { print $1 ":" $2+1 "-" $3 }' > $chunk_int
 		
		chunk_gvcf=$analysis_dir/chunks/$input_gvcf_name.$chunk.genomic.vcf

		echo "`${NOW}`INFO extracting chunk from input GVCF..."

		java -Xmx$JAVA_XMX -XX:+UseSerialGC -Djava.io.tmpdir=$TMPDIR/tmp -jar $GATK_HOME/GenomeAnalysisTK.jar \
			-T SelectVariants \
			-R $TMPDIR/reference.fa \
			-V $input_gvcf \
			-L $chunk_int \
			-o $chunk_gvcf&

		PROCESS_IDS="$PROCESS_IDS $!"

	fi

done

#wait to finish
echo "`${NOW}`INFO waiting for chunk extraction to finish..."
#wait $PROCESS_IDS
checkStatus
echo "`${NOW}`INFO done"

echo "`${NOW}`INFO copying of GVCF files and index files..."
PROCESS_IDS=""
for CHUNK_GVCF in `ls $analysis_dir/chunks/$input_gvcf_name.*.vcf`
do

    echo "`$NOW`$CHUNK_GVCF"
    cp $CHUNK_GVCF $OUTPUT_DIR&
    PROCESS_IDS="$PROCESS_IDS $!"
    cp $CHUNK_GVCF.idx $OUTPUT_DIR
    PROCESS_IDS="$PROCESS_IDS $!"

done;

#wait for copy to finish
echo "`${NOW}`INFO $SCRIPT_CODE waiting for copying to finish..."
#wait $PROCESS_IDS
checkStatus
echo "`${NOW}`INFO $SCRIPT_CODE done"

ls -al
ls -al $analysis_dir/chunks

#cp $TMPDIR/chunks/*intervals $OUTPUT_DIR

du -h $TMPDIR

echo "`${NOW}`INFO $SCRIPT_CODE done"
