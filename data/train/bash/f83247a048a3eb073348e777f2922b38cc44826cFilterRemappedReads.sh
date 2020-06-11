#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -l h_vmem=20G
#

BASEDIR=/c8000xd3/rnaseq-heath/ASEmappings

# see http://www.tldp.org/LDP/LG/issue18/bash.html for bash Parameter Substitution
for SampleID in $@
#for input in `find /c8000xd3/rnaseq-heath/Mappings/ -name *.chr.nonref.merged.dedup.sort.clip.bam`
do
    
    echo "Started processing $SampleID"
    python ~/src/WASP-0.2.1/mapping/filter_remapped_reads.py \
          $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_sort.to.remap.bam \
          $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort.bam \
          $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep.bam 
    echo "Finished processing $SampleID"
done
exit $?
