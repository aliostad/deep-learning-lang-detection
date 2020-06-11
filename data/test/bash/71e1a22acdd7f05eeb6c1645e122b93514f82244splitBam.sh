#!/bin/bash

## script to run GATK

#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=#threads:mem=2gb:tmpspace=#tmpSpaceGbgb

#PBS -M igf@imperial.ac.uk
#PBS -m ea
#PBS -j oe

#PBS -q pqcgi

NOW="date +%Y-%m-%d%t%T%t"


module load samtools/#samtoolsVersion

INPUT_BAM_SCRATCH=#inputBam
REFERENCE_CHUNKS=#chunkBed
OUTPUT_DIR=#outputDir
RUN_DIR=#runDir
SUBSET=#subset
SAMPLE=#sample
RUN_LOG=#runLog
SUMMARY_SCRIPT_PATH=#summaryScriptPath
LAST_SUBSET=#lastSubset

input_bam_name=`basename $INPUT_BAM_SCRATCH .bam`
input_bam=$TMPDIR/$input_bam_name.bam

SCRIPT_CODE="GATKSPBA"

LOG_INFO="`${NOW}`INFO $SCRIPT_CODE"
LOG_ERR="`${NOW}`ERROR $SCRIPT_CODE"
LOG_WARN="`${NOW}`WARN $SCRIPT_CODE"
LOG_DEBUG="`${NOW}`DEBUG $SCRIPT_CODE"

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

echo "`${NOW}`INFO $SCRIPT_CODE copying input BAM file and index to $TMPDIR..." 
cp $INPUT_BAM_SCRATCH $input_bam
cp $INPUT_BAM_SCRATCH.bai $input_bam.bai
echo "`${NOW}`INFO $SCRIPT_CODE done"

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

echo "`${NOW}`INFO $SCRIPT_CODE starting chunk extraction..."
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
#		cat $REFERENCE_DICT > $chunk_int
#		grep -P "chunk_${chunk_name}\." $REFERENCE_CHUNKS | awk '/^\s*$/ {next;} { print $1 "\t" $2+1 "\t" $3 "\t+\t" $4 }' > $chunk_int
		grep -P "chunk_${chunk_name}\." $REFERENCE_CHUNKS | awk '/^\s*$/ {next;} { print $1 ":" $2+1 "-" $3 }' > $chunk_int
 		
		echo "`${NOW}`INFO $SCRIPT_CODE creating chunk BED file..."
		grep -P "chunk_${chunk_name}\." $REFERENCE_CHUNKS > $chunk_bed

		chunk_bam=$analysis_dir/chunks/$input_bam_name.$chunk.bam

		# check whether the last subset
		# we only include unmapped reads in the last chunk of the last subset

		if [[ $LAST_SUBSET == "F" ]]; then

			# generate region argument to use with samtools view
			region=`echo $analysis_dir/chunks/$chunk.bed | perl -e '$input=<>; open(IN, "<$input"); 
                   		              $regions; 
                	    		      while(<IN>){ 
						@cols=split; 
						$regions=$regions.$cols[0].":".($cols[1]+1)."-".$cols[2]." ";
					      } 
                                	      print $regions;'` 

			# we use the region option instead of the -L option
			# as the latter will also output unmapped reads		
			#echo "samtools view -b $input_bam -o $chunk_bam $region"
			echo "`${NOW}`INFO $SCRIPT_CODE extracting chunk from input BAM..."
			echo "`${NOW}`DEBUG $SCRIPT_CODE samtools view -b $input_bam -o $chunk_bam $region&" 
			samtools view -b $input_bam -o $chunk_bam $region&
				
			PROCESS_IDS="$PROCESS_IDS $!"
			#echo "`$NOW`indexing chunk BAM..."
			#samtools index $chunk_bam&
			#echo "`$NOW`PROCESS_IDS=$PROCESS_IDS"

		elif [[ $chunk_count -ne $TOTAL_CHUNK_COUNT ]]; then

			# generate region argument to use with samtools view
			region=`echo $analysis_dir/chunks/$chunk.bed | perl -e '$input=<>; open(IN, "<$input"); 
                   		              $regions; 
                	    		      while(<IN>){ 
						@cols=split; 
						$regions=$regions.$cols[0].":".($cols[1]+1)."-".$cols[2]." ";
					      } 
                                	      print $regions;'` 

			# we use the region option instead of the -L option
			# as the latter will also output unmapped reads		
			#echo "samtools view -b $input_bam -o $chunk_bam $region"
			echo "`${NOW}`INFO $SCRIPT_CODE extracting chunk from input BAM..."
			echo "`${NOW}`DEBUG $SCRIPT_CODE samtools view -b $input_bam -o $chunk_bam $region&" 
			samtools view -b $input_bam -o $chunk_bam $region&
				
			PROCESS_IDS="$PROCESS_IDS $!"
			#echo "`$NOW`indexing chunk BAM..."
			#samtools index $chunk_bam&
			#echo "`$NOW`PROCESS_IDS=$PROCESS_IDS"
		else
					
			includes_unmapped=T

			# In the last chunk we want to include the unmapped reads.
			# So here we use the -L option which will output unmapped
			# reads as well.
			
			echo "`${NOW}`INFO $SCRIPT_CODE extracting chunk from input BAM..."
			echo "`${NOW}`DEBUG $SCRIPT_CODE samtools view -b $input_bam -L $chunk_bed -o $chunk_bam&"
			samtools view -b $input_bam -L $chunk_bed -o $chunk_bam&
			#echo "`$NOW`indexing chunk BAM..."
			#samtools index $chunk_bam
			PROCESS_IDS="$PROCESS_IDS $!"
			#echo "`$NOW`PROCESS_IDS=$PROCESS_IDS"

		fi
			
		#cp $chunk_bam $OUTPUT_DIR&

	fi

done


#wait for samtools view to finish
echo "`${NOW}`INFO $SCRIPT_CODE waiting for chunk extraction to finish..."
#wait $PROCESS_IDS
checkStatus
echo "`${NOW}`INFO $SCRIPT_CODE done"

echo "`${NOW}`INFO $SCRIPT_CODE starting indexing of chunk BAMs..."
PROCESS_IDS=""
for CHUNK_BAM in `ls $analysis_dir/chunks/$input_bam_name.*.bam`
do

    echo "`${NOW}`INFO $SCRIPT_CODE $CHUNK_BAM..."
    samtools index $CHUNK_BAM&
    PROCESS_IDS="$PROCESS_IDS $!"

done;

#wait for the indexing to finish
echo "`${NOW}`INFO $SCRIPT_CODE waiting for indexing to finish..."
checkStatus
#wait $PROCESS_IDS
echo "`${NOW}`INFO $SCRIPT_CODE done"

echo "`${NOW}`INFO $SCRIPT_CODE copying of BAM files and index files..."
PROCESS_IDS=""
for CHUNK_BAM in `ls $analysis_dir/chunks/$input_bam_name.*.bam`
do

    echo "`$NOW`$CHUNK_BAM"
    cp $CHUNK_BAM $OUTPUT_DIR&
    PROCESS_IDS="$PROCESS_IDS $!"
    cp $CHUNK_BAM.bai $OUTPUT_DIR
    PROCESS_IDS="$PROCESS_IDS $!"

done;

#wait for copy to finish
echo "`${NOW}`INFO $SCRIPT_CODE waiting for copying to finish..."
#wait $PROCESS_IDS
checkStatus
echo "`${NOW}`INFO $SCRIPT_CODE done"

ls -al
ls -al $analysis_dir/chunks

for chunk_name in `cut -f 5 $REFERENCE_CHUNKS | sort -n | uniq`
do

	chunk="chunk_$chunk_name"
	#logging
	STATUS=OK
	if [[ ! -e $OUTPUT_DIR/$input_bam_name.$chunk.bam ]]
	then
		STATUS=FAILED
	fi

	echo -e "`${NOW}`$SCRIPT_CODE\t$SAMPLE\t$chunk\tchunk_bam\t$STATUS" >> $RUN_LOG

done

#run summary script
perl $SUMMARY_SCRIPT_PATH

echo "`${NOW}`INFO $SCRIPT_CODE done"
