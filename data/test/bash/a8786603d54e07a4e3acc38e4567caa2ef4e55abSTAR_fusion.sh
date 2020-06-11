#!/bin/bash
# Run STAR fusion on Chimeric.out.junction files produced by STAR aligner to predict fusion transcripts
# Written by David Coffey dcoffey@fhcrc.org
# Updated September 26, 2015

## Prerequisites (see Software_installation.sh)
# Download and install STAR fusion
# Download and install perl
# Download and install Set::IntervalTree and DB_File perl modules
# Run STAR_aligner.sh script

## Variables
# export STAR_FUSION=".../STAR-Fusion/STAR-Fusion"
# export SAMPLE="..."
# export GTF_FILE=".../hg19.gtf"
# export ALIGNMENT_DIRECTORY=".../STAR_alignment/hg19/$SAMPLE"
# export PERL5LIB=$PERL5LIB:.../perl5/lib/perl5
# export LAST_SAMPLE="..."
# export EMAIL="..."

START=`date +%s`
echo Begin STAR_fusion.sh for sample $SAMPLE on `date +"%B %d, %Y at %r"`

# Run Star Fusion
perl $STAR_FUSION \
--chimeric_junction $ALIGNMENT_DIRECTORY/$SAMPLE.Chimeric.out.junction \
--ref_GTF $GTF_FILE \
--out_prefix $ALIGNMENT_DIRECTORY/$SAMPLE

# Clean up
rm $ALIGNMENT_DIRECTORY/$SAMPLE.fusion_candidates.final.abridged
rm $ALIGNMENT_DIRECTORY/$SAMPLE.fusion_candidates.preliminary
rm $ALIGNMENT_DIRECTORY/$SAMPLE.STAR-Fusion.filter.ok
rm $ALIGNMENT_DIRECTORY/$SAMPLE.STAR-Fusion.predict.ok
rm -R $ALIGNMENT_DIRECTORY/$SAMPLE.filter.intermediates_dir
rm -R $ALIGNMENT_DIRECTORY/$SAMPLE.predict.intermediates_dir

END=`date +%s`
MINUTES=$(((END-START)/60))
echo End STAR_fusion.sh for sample $SAMPLE.  The run time was $MINUTES minutes.

if [[ $SAMPLE = $LAST_SAMPLE ]]
then
	echo "The runtime was $MINUTES minutes" | mail -s "Finished STAR_fusion.sh for sample $LAST_SAMPLE" $EMAIL
fi
