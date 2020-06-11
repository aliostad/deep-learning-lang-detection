#!/bin/bash
# Process alignment files
# Written by David Coffey dcoffey@fhcrc.org
# Updated February 8, 2016

## Prerequisites (see Software_installation.sh)
# Download and install picard tools
# Download and install samtools
# Download and install IGVtools

## Variables
# export GENOME="..."
# export SAMPLE="..."
# export IGV_GENOME=".../$GENOME.genome"
# export ALIGNMENT_DIRECTORY=""
# export PICARD=".../picard.jar"
# export SAMTOOLS=".../samtools/1.0/bin/samtools"
# export IGVTOOLS=".../IGVTools/2.3.26/igvtools"
# export LAST_SAMPLE="..."
# export EMAIL="..."

START=`date +%s`
echo Begin Process_alignment.sh for sample $SAMPLE on `date +"%B %d, %Y at %r"`

# Index Aligned.bam 
$SAMTOOLS index $ALIGNMENT_DIRECTORY/$SAMPLE.Aligned.bam
mv -f $ALIGNMENT_DIRECTORY/$SAMPLE.Aligned.bam.bai $ALIGNMENT_DIRECTORY/$SAMPLE.Aligned.bai

# Index Chimeric.out.bam file
$SAMTOOLS index $ALIGNMENT_DIRECTORY/$SAMPLE.Chimeric.out.bam
mv -f $ALIGNMENT_DIRECTORY/$SAMPLE.Chimeric.out.bam.bai $ALIGNMENT_DIRECTORY/$SAMPLE.Chimeric.out.bai

# Compute the average number of reads over a 25bp window across the genome for use with IGV
$IGVTOOLS count $ALIGNMENT_DIRECTORY/$SAMPLE.Aligned.bam \
$ALIGNMENT_DIRECTORY/$SAMPLE.Aligned.tdf \
$IGV_GENOME
rm igv.log

# Calculate alignment statistics
java -jar $PICARD BamIndexStats \
INPUT=$ALIGNMENT_DIRECTORY/$SAMPLE.Aligned.bam > \
$ALIGNMENT_DIRECTORY/$SAMPLE.alignment.stats.txt

# Move log files
mkdir $ALIGNMENT_DIRECTORY/$SAMPLE.logs
mv $ALIGNMENT_DIRECTORY/*Log* $ALIGNMENT_DIRECTORY/$SAMPLE.logs

END=`date +%s`
MINUTES=$(((END-START)/60))
echo End Process_alignment.sh for sample $SAMPLE.  The run time was $MINUTES minutes.

if [[ $SAMPLE = $LAST_SAMPLE ]]
then
	echo "The runtime was $MINUTES minutes" | mail -s "Finished Process_alignments.sh for sample $LAST_SAMPLE" $EMAIL
fi
