#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe smp 2
#$ -l h_vmem=20G
#

BASEDIR=/c8000xd3/rnaseq-heath/ASEmappings

# see http://www.tldp.org/LDP/LG/issue18/bash.html for bash Parameter Substitution
SampleID=$1
#bash ~/LabNotes/SubmissionScripts/RenameFiles $SampleID

echo "Combining mappings for $SampleID"

if [ ! -d $BASEDIR/$SampleID ]
then
    echo "Making directory $BASEDIR/$SampleID"
    mkdir $BASEDIR/$SampleID
    if [ $? -eq 0 ]
    then
        echo "Finished making directory $BASEDIR/$SampleID"
    else
        echo "Could make directory $BASEDIR/$SampleID"
        exit 1
    fi
fi

# for samples with a single mapping, rename files and delete everything that is unnecessary
if [ ! -d $BASENAME/${SampleID}-1 ]
then
    echo "Merging not necessary for $SampleID. Renaming files"
    mv $BASENAME/${SampleID}/find_intersecting_snps/${SampleID}_remap_sort_keep_merge_sort_dedup_sort_RG.bam $BASENAME/${SampleID}/${SampleID}.bam
    mv $BASENAME/${SampleID}/${SampleID}_sort_stats.txt $BASENAME/${SampleID}/${SampleID}_stats.txt
    #rm -rf $BASENAME/${SampleID}/find_intersecting_snps
    #rm $BASENAME/${SampleID}/${SampleID}_sort*
fi

if [ ! -f $BASEDIR/$SampleID/$SampleID.bam ]
then
    echo "Merging mappings for $SampleID"
    bash ~/LabNotes/SubmissionScripts/MergeSAM.sh `find /c8000xd3/rnaseq-heath/ASEmappings/${SampleID}-*/find_intersecting_snps/ -name ${SampleID}-*_remap_sort_keep_merge_sort_dedup_sort_RG.bam | grep $SampleID- | sort`

    if [ $? -eq 0 ]
    then
        echo "Finished merging mappings for $SampleID"
    else
        echo "Could merge mappings for $SampleID"
        exit 1
    fi
    mv $BASEDIR/$SampleID-1/find_intersecting_snps/${SampleID}-1_remap_sort_keep_merge_sort_dedup_sort_RG_merge.bam $BASEDIR/$SampleID/$SampleID.bam
    #rm -rf $BASENAME/${SampleID}-*
fi

if [ ! -f $BASEDIR/$SampleID/$SampleID.bam.bai ]
then
    echo "Indexing merged mappings for $SampleID"
    bash ~/LabNotes/SubmissionScripts/SamtoolsIndex.sh $BASEDIR/$SampleID/$SampleID.bam

    if [ $? -eq 0 ]
    then
        echo "Finished indexing merged mappings for $SampleID"
    else
        echo "Could index merged mappings for $SampleID"
        exit 1
    fi
fi

if [ ! -f $BASEDIR/$SampleID/${SampleID}_stats.txt ]
then
    echo "Collecting stats on merged mapping for $SampleID"
    bam_stat.py -i $BASEDIR/$SampleID/${SampleID}.bam > $BASEDIR/$SampleID/${SampleID}_stats.txt

    if [ $? -eq 0 ]
    then
        echo "Finished collecting stats on merged mappings for $SampleID"
    else
        echo "Could colect stats on merged mappings for $SampleID"
        exit 1
    fi
fi

echo "Finished combining mappings for $SampleID"
exit $?

