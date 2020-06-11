#!/bin/bash

# part 0 of medusa pipeline - written by Gareth Wilson
# runs initial alignment and filtering. Currently performed using BWA (http://bio-bwa.sourceforge.net/) and samtools (http://samtools.sourceforge.net/).
# limited alignment parameters are passed from medusa.pl. defaults have generally worked well for our data. More parameters can be added if required (edit PARAM_BWA_ALN or PARAM_BWA_SAMPE).
# in future no reason why other alignment programme can't be used - just need to ensure output is in sam format.

SAMPLE=$1
PATH2READS=$2
PATH2GENOME=$3
READ1=$4
READ2=$5
BWAGENOME=$6
SAMGENOME=$7
PATH2OUTPUT=$8
MAX_INSERT=$9
BWA_THREADS=${10}

INPUT1=$PATH2READS/$READ1
INPUT2=$PATH2READS/$READ2
IN_GENOME=$PATH2GENOME/$BWAGENOME
IN_S_GENOME=$PATH2GENOME/$SAMGENOME

PARAM_BWA_ALN="-t $BWA_THREADS $IN_GENOME" 
PARAM_BWA_SAMPE="-a $MAX_INSERT -P $IN_GENOME"
PARAM_SAM="-S -t $IN_S_GENOME"".fai -b"

echo "bwa aln $PARAM_BWA_ALN $INPUT1 >$PATH2OUTPUT/$SAMPLE""_1.sai"
bwa aln $PARAM_BWA_ALN $INPUT1 >$PATH2OUTPUT/$SAMPLE""_1.sai
echo "bwa aln $PARAM_BWA_ALN $INPUT2 >$PATH2OUTPUT/$SAMPLE""_2.sai"
bwa aln $PARAM_BWA_ALN $INPUT2 >$PATH2OUTPUT/$SAMPLE""_2.sai
bwa sampe $PARAM_BWA_SAMPE $PATH2OUTPUT/$SAMPLE""_1.sai $PATH2OUTPUT/$SAMPLE""_2.sai $INPUT1 $INPUT2 >$PATH2OUTPUT/$SAMPLE"".sam
samtools view $PARAM_SAM $PATH2OUTPUT/$SAMPLE"".sam >$PATH2OUTPUT/$SAMPLE"".bam
samtools sort $PATH2OUTPUT/$SAMPLE"".bam $PATH2OUTPUT/$SAMPLE"".sorted

# test to make sure the sorted bam file exists and contains data prior to removing sam file
FILE=$PATH2OUTPUT/$SAMPLE.sorted.bam
if [[ -s $FILE ]] ; then
echo "$FILE has data. Removing $PATH2OUTPUT/$SAMPLE"".sam"
rm $PATH2OUTPUT/$SAMPLE"".sam
else
echo "$FILE is empty. $PATH2OUTPUT/$SAMPLE"".sam will not be deleted"
fi ;

samtools index $PATH2OUTPUT/$SAMPLE"".sorted.bam
samtools view -f 2 $PATH2OUTPUT/$SAMPLE"".sorted.bam >$PATH2OUTPUT/$SAMPLE""_filter.sam

# test to make sure the filtered sam file exists and contains data prior to removing bam file
FILE=$PATH2OUTPUT/$SAMPLE""_filter.sam
if [[ -s $FILE ]] ; then
echo "$FILE has data. Removing $PATH2OUTPUT/$SAMPLE"".bam"
rm $PATH2OUTPUT/$SAMPLE"".bam
else
echo "$FILE is empty. $PATH2OUTPUT/$SAMPLE"".bam will not be deleted"
fi ;
