#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#

# This will take an individual pair of read files and take them through all steps of
# mapping, remapping, deduplicating and read group addition.
# Once this has been run on all datasets for a sample, they can be combined and used for
# allele-specific read counting using CombineMappings.sh

#export PATH=/share/apps/R-3.2.2/bin:/share/apps/:$PATH

# see http://www.tldp.org/LDP/LG/issue18/bash.html for bash Parameter Substitution
SampleID=$1 
MAPPER=HISAT2
BASEDIR=/c8000xd3/rnaseq-heath/ASEmappings
ANNOTATION=/c8000xd3/rnaseq-heath/Ref/Homo_sapiens/GRCh38/NCBI/GRCh38Decoy/Annotation/Genes.gencode
REF=/c8000xd3/rnaseq-heath/Ref/Homo_sapiens/GRCh38/NCBI/GRCh38Decoy/Sequence/WholeGenomeFasta
seq_folder=$(grep -P "\s$SampleID(\s|$)"  ~/LabNotes/sequences.txt | cut -f 5 | head -1)
sequences=$(for name in `grep -P "\s$SampleID(\s|$)"  ~/LabNotes/sequences.txt | cut -f 1`; do find $seq_folder -name $name*f*q.gz; done)

echo "Starting mapping for $BASEDIR/$SampleID"
if [ ! -d $BASEDIR/$SampleID ]
then
    echo "Creating directory $BASEDIR/$SampleID"
    mkdir $BASEDIR/$SampleID
    if [ $? -eq 0 ]
    then
        echo "Finished creating directory for $BASEDIR/$SampleID"
    else
        echo "Could not create directory for $BASEDIR/$SampleID"
        exit 1
    fi    
fi

if [ ! -f $BASEDIR/$SampleID/$SampleID.bam ]
then
    echo "$MAPPER mapping for $SampleID"
    if [ ! $sequences ]
    then
        echo "trying without gzip"
        sequences=$(for name in `grep -P "\s$SampleID(\s|$)"  ~/LabNotes/sequences.txt | cut -f 1`; do find $seq_folder -name $name*f*q; done)
    fi
    if [ ! $sequences ]
    then
        echo "could not find sequence files for $SampleID"
        exit 1
    fi
    echo "Read files: $sequences"
    sequences="$sequences $BASEDIR/$SampleID/$SampleID.bam" # Add output file to arguments
    qsub -N h${SampleID}_map ~/LabNotes/SubmissionScripts/HISAT2.sh $sequences
#     if [ $? -eq 0 ]
#     then
#         echo "Finished $MAPPER mapping for $SampleID"
#     else
#         echo "$MAPPER mapping failed on $SampleID"
#         rm $BASEDIR/$SampleID/$SampleID.bam
#         exit 1
#     fi    
fi

if [ ! -f $BASEDIR/$SampleID/${SampleID}_sort.bam ]
then
    echo "Sorting $SampleID"
    qsub -N h${SampleID}_sort1 -hold_jid h${SampleID}_map \
      ~/LabNotes/SubmissionScripts/SamtoolsSort.sh \
      $BASEDIR/$SampleID/$SampleID.bam
#     if [ $? -eq 0 ]
#     then
#         echo "Finished sorting for $SampleID"
#     else
#         echo "Could not sort BAM for $SampleID"
#         exit 1
#     fi
fi   

if [ ! -f $BASEDIR/$SampleID/${SampleID}_sort.bam.bai ]
then
    echo "Indexing $SampleID"
    qsub -N h${SampleID}_index1 -hold_jid h${SampleID}_sort1 \
      ~/LabNotes/SubmissionScripts/SamtoolsIndex.sh \
      $BASEDIR/$SampleID/${SampleID}_sort.bam    
#     if [ $? -eq 0 ]
#     then
#         echo "Finished indexing for $SampleID"
#     else
#         echo "Could not index BAM for $SampleID"
#         exit 1
#     fi
fi

# 1118.769 CPU / 1121 Wallclock = 1
if [ ! -f $BASEDIR/$SampleID/${SampleID}_sort_stats.txt ]
then
    echo "Running RNAseqQC $SampleID"
    qsub -N h${SampleID}_stats -hold_jid h${SampleID}_index1 \
      ~/LabNotes/SubmissionScripts/GetStats.sh \
      $BASEDIR/$SampleID/${SampleID}_sort.bam
#     if [ $? -eq 0 ]
#     then
#         echo "Finished running RNAseqQC for $SampleID"
#     else
#         echo "Could not run RNAseqQC for $SampleID"
#         exit 1
#     fi
fi

# 77140.787 CPU / 77475 Wallclock
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_sort.remap.fq1.gz ] || [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_sort.remap.fq2.gz ]
then
    echo "finding intersecting SNPs for $SampleID"
    mkdir $BASEDIR/$SampleID/find_intersecting_snps
    qsub -N h${SampleID}_wasp1 -hold_jid h${SampleID}_index1 \
      ~/LabNotes/SubmissionScripts/FindIntersectingSNPS.sh \
      $BASEDIR/$SampleID/${SampleID}_sort.bam
#     if [ $? -eq 0 ]
#     then
#         echo "Finished finding intersecting SNPs for $SampleID"
#     else
#         echo "Could not find intersecting SNPs $SampleID"
#         exit 1
#     fi  
fi  

#29495.830 CPU / 3635 Wallclock = 8.11
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap.bam ]
then
    echo "remapping reads with intersecting SNPs for $SampleID"
    qsub -N h${SampleID}_remap -hold_jid h${SampleID}_wasp1 ~/LabNotes/SubmissionScripts/HISAT2.sh \
      $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_sort.remap.fq1.gz \
      $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_sort.remap.fq2.gz \
      $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap.bam

#     if [ $? -eq 0 ]
#     then
#         echo "Finished remapping reads for $SampleID"
#     else
#         echo "Could not remap reads for $SampleID"
#         exit 1
#     fi
fi
     
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort.bam ]
then
    echo "Sorting remapped BAM $SampleID"
    qsub -N h${SampleID}_sort2 -hold_jid h${SampleID}_remap \
      ~/LabNotes/SubmissionScripts/SamtoolsSort.sh \
      $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap.bam
      
#     if [ $? -eq 0 ]
#     then
#         echo "Finished sorting remapped BAM for $SampleID"
#     else
#         echo "Could not sort remapped BAM for $SampleID"
#         exit 1
#     fi
fi   

# 210.741 CPU / 218 Wallclock
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort.bam.bai ]
then
    echo "Indexing remapped BAM for $SampleID"
    qsub -N h${SampleID}_index2 -hold_jid h${SampleID}_sort2 \
      ~/LabNotes/SubmissionScripts/SamtoolsIndex.sh \
       $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort.bam    
#     if [ $? -eq 0 ]
#     then
#         echo "Finished indexing remapped BAM for $SampleID"
#     else
#         echo "Could not index remapped BAM for $SampleID"
#         exit 1
#     fi
fi

# 5241.446 CPU / 5805 Wallclock
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep.bam ]
then
    echo "Filtering remapped reads for $SampleID"
    qsub -N h${SampleID}_filter -hold_jid h${SampleID}_index2 \
      ~/LabNotes/SubmissionScripts/FilterRemappedReads.sh $SampleID
#     if [ $? -eq 0 ]
#     then
#         echo "Finished filtering remapped reads for $SampleID"
#     else
#         echo "Could not filter remapped reads for $SampleID"
#         exit 1
#     fi
fi

# 1962.853 CPU / 1964 Wallclock
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge.bam ]
then
    echo "Merging filtered reads for $SampleID"
    qsub -N h${SampleID}_merge -hold_jid h${SampleID}_filter \
      ~/LabNotes/SubmissionScripts/SamtoolsMerge.sh \
              $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep.bam  \
              $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_sort.keep.bam
#     if [ $? -eq 0 ]
#     then
#         echo "Finished merging filtered reads for $SampleID"
#     else
#         echo "Could not merge filtered reads for $SampleID"
#         exit 1
#     fi
fi

if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort.bam ]
then
    echo "Sorting filtered BAM $SampleID"
    qsub -N h${SampleID}_sort3 -hold_jid h${SampleID}_merge \
      ~/LabNotes/SubmissionScripts/SamtoolsSort.sh \
      $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge.bam 
#     if [ $? -eq 0 ]
#     then
#         echo "Finished sorting filtered BAM for $SampleID"
#     else
#         echo "Could not sort filtered BAM for $SampleID"
#         exit 1
#     fi
fi   

if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort.bam.bai ]
then
    echo "Indexing filtered BAM for $SampleID"
    qsub -N h${SampleID}_index3 -hold_jid h${SampleID}_sort3 \
      ~/LabNotes/SubmissionScripts/SamtoolsIndex.sh \
       $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort.bam 
#     if [ $? -eq 0 ]
#     then
#         echo "Finished indexing filtered BAM for $SampleID"
#     else
#         echo "Could not index filtered BAM for $SampleID"
#         exit 1
#     fi
fi

# 3552.248 CPU / 3599 wallclock = 0.99
if [ ! -f  $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort_dedup.bam ]
then
    echo "Deduplicating filtered BAM for $SampleID"
    qsub -N h${SampleID}_dedup -hold_jid h${SampleID}_index3 \
      ~/LabNotes/SubmissionScripts/Dedup.sh \
       $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort.bam
#     if [ $? -eq 0 ]
#     then
#         echo "Finished deduplicating filtered BAM for $SampleID"
#     else
#         echo "Could not deduplicate filtered BAM for $SampleID"
#         exit 1
#     fi
fi

#4128.530 CPU / 4195 Wallclock = 0.98
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort_dedup_sort.bam ]
then
    echo "Sorting filtered, deduplicated BAM for $SampleID"
    # Sort BAM files by query name
    qsub -N h${SampleID}_sort4 -hold_jid h${SampleID}_dedup \
    ~/LabNotes/SubmissionScripts/SamtoolsSort.sh \
    $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort_dedup.bam 
#     if [ $? -eq 0 ]
#     then
#         echo "Finished sorting filtered, deduplicated BAM for $SampleID"
#     else
#         echo "Could not sort filtered, deduplicated BAM for $SampleID"
#         exit 1
#     fi    
fi

# 1862.636 CPU = 1719 Wallclock
if [ ! -f $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort_dedup_sort_RG.bam ]
then
    echo "Adding read groups for $SampleID"
    qsub -N h${SampleID}_rg -hold_jid h${SampleID}_sort4 \
      ~/LabNotes/SubmissionScripts/AddRG.sh \
      $BASEDIR/$SampleID/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort_dedup_sort.bam \
      $SampleID
    if [ $? -eq 0 ]
    then
        echo "Finished adding read groups for $SampleID"
    else
        echo "could not add read groups for $SampleID"
        exit 1
    fi
fi
echo "Finished mapping for $SampleID"
exit $?

