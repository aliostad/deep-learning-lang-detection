#!/bin/bash

#creates counts table
#to be used as input to DESeq 

#PBS -l walltime=72:00:00
#PBS -l ncpus=1
#PBS -l mem=100gb

#PBS -M igf@imperial.ac.uk
#PBS -m bea
#PBS -j oe

MEDIPS_DIR="#medipsDir"
SAMPLE_INFO="#sampleInfo"
PROJECT="#project"

for CONDITION in `sed 1d $SAMPLE_INFO | cut -f2 | grep -vP "^$" | sort | uniq `;do

	PROFILE="$MEDIPS_DIR/WIG/${CONDITION}_profile.txt"
	sed 1d $PROFILE | cut -f 2,3,4 | sed 's/"//g' | awk -F $'\t' '{print $1 ":" $2 "-" $3}' > $TMPDIR/coord.table

	for SAMPLE in `sed 1d $SAMPLE_INFO | grep $CONDITION | cut -f1 | grep -vP "^$"`; do

		COLUMN=`head -n 1 $PROFILE | sed s/\"//g | perl -e '$sample = shift; $sample .= ".counts"; while(<>){@names=split(/\t/,$_); $column=1; foreach $name (@names) {$column++; last if "$name" eq "$sample"} print "$column";}' $SAMPLE`
echo "$SAMPLE $COLUMN"

		sed 1d $PROFILE | cut -f $COLUMN > $TMPDIR/$SAMPLE.table

		mkdir -m 0775 $MEDIPS_DIR/$SAMPLE
		paste $TMPDIR/coord.table $TMPDIR/$SAMPLE.table > $MEDIPS_DIR/$SAMPLE/$SAMPLE.HTSeq.counts

	done
done


