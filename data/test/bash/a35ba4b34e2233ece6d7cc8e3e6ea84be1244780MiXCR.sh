#!/bin/bash
# Extract antigen receptor sequences using MiXCR
# Written by David Coffey dcoffey@fhcrc.org
# Updated February 16, 2016

## Prerequisites (see Software_installation.sh)
# Install MiXCR

## Variables
# export MIXCR=".../MiXCR-1.7/mixcr"
# export SAMPLE="..."
# export LAST_SAMPLE="..."
# export EMAIL="..."
# export MIXCR_DIRECTORY=".../MiXCR"
# export READ1="..."
# export READ2="..."

START=`date +%s`
echo Begin MiXCR.sh for sample $SAMPLE on `date +"%B %d, %Y at %r"`

LOCUS="IGH IGK IGL TRB TRA"

for L in ${LOCUS}; do
    echo ${L} $SAMPLE
    mkdir -p $MIXCR_DIRECTORY/${L}

	# Align
    $MIXCR align \
    --loci ${L} \
    --parameters rna-seq \
    $READ1 \
    $READ2 \
    $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.vdjca
    
    # Assemble
    $MIXCR assemble \
    $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.vdjca $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.clns
    
    # Export
    $MIXCR exportClones \
    --filter-out-of-frames \
    -aaFeature CDR3 \
    -nFeature CDR3 \
    -count \
    -fraction \
    -vHit \
    -dHit \
    -jHit \
    -cHit \
    -vAlignment \
    -dAlignment \
    -jAlignment \
    -cAlignment \
    -minFeatureQuality CDR3 \
    -avrgFeatureQuality CDR3 \
    $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.clns $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
    
    # Rename columns
    sed -i 's/AA. Seq. CDR3/aminoAcid/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/N. Seq. CDR3/nucleotide/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Clone count/count/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Clone fraction/frequencyCount/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best V hit/vGeneName/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best D hit/dGeneName/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best J hit/jGeneName/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best C hit/cGeneName/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best V alignment/vGeneAlignment/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best D alignment/dGeneAlignment/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best J alignment/jGeneAlignment/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Best C alignment/cGeneAlignment/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Min. qual. CDR3/minQuality/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	sed -i 's/Mean. qual. CDR3/meanQuality/g' $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt
	mv $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.txt $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.tsv
    
    # Clean up
    rm $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.clns
    rm $MIXCR_DIRECTORY/${L}/$SAMPLE.${L}.vdjca
done

END=`date +%s`
MINUTES=$(((END-START)/60))
echo End MiXCR.sh for sample $SAMPLE.  The run time was $MINUTES minutes.

if [[ $SAMPLE = $LAST_SAMPLE ]]
then
	echo "The runtime was $MINUTES minutes" | mail -s "Finished MiXCR.sh for sample $LAST_SAMPLE" $EMAIL
fi
