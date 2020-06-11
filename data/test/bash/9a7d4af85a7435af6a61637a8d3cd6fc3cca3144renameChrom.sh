#!/bin/bash

# runs filtering of BAM files

#PBS -l walltime=72:00:00
#PBS -l ncpus=2
#PBS -l mem=100gb

#PBS -M igf@imperial.ac.uk
#PBS -m bea
#PBS -j oe

module load samtools/#samtoolsVersion

MERGETAG_DIR="#mergetagDir"
FILTERED_DIR="#filteredDir"
SAMPLE="#sample"
RENAME_CHROM="#renameChrom"

cp $MERGETAG_DIR/$SAMPLE/$SAMPLE.bam $TMPDIR/$SAMPLE.bam

echo "renaming chromosome names to hg19 from sample $SAMPLE..."

samtools view -h -F 4 $TMPDIR/$SAMPLE.bam \
| perl -e '$rename_chrom = shift; open(CHROM,"$rename_chrom"); %rename = (); while (<CHROM>){ /(.*)\t(.*)/; $rename{$1} = $2;} while(<>) {if (/^@/ && /SN:/) { s/(.*\tSN:)(.*)(\t.*)/$1$rename{$2}$3/; print } elsif (/^@/) { print } else { @cols = split(/\t/); $cols[2] =~ s/(.*)/$rename{$1}/; $cols[6] =~ s/(.*)/$rename{$1}/ unless $cols[6] eq "="; $line = ""; foreach $col (@cols) { $line .= $col."\t"; } chop($line); print "$line" } }' $RENAME_CHROM | samtools view -bS -  > $TMPDIR/$SAMPLE.hg19.bam

samtools index $TMPDIR/$SAMPLE.hg19.bam

cp $TMPDIR/$SAMPLE.hg19.bam $FILTERED_DIR/$SAMPLE/$SAMPLE.hg19.bam
cp $TMPDIR/$SAMPLE.hg19.bam.bai $FILTERED_DIR/$SAMPLE/$SAMPLE.hg19.bam.bai

ls -lh



