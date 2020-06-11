#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe smp 2

#

BASEDIR=/c8000xd3/rnaseq-heath/ASEmappings

# see http://www.tldp.org/LDP/LG/issue18/bash.html for bash Parameter Substitution
SampleID=$1
#bash ~/LabNotes/SubmissionScripts/RenameFiles $SampleID

for chr in {1..22}
do
    if [ ! -f $BASEDIR/$SampleID/$SampleID.$chr.ase.rtable ]
    then
        echo "Running ASEReadCounter on $chr for $SampleID"
        qsub ~/LabNotes/SubmissionScripts/ASEReadCounter.sh $BASEDIR/$SampleID/$SampleID.bam $chr
#        if [ $? -eq 0 ]
#        then
#            echo "Finished running ASEReadCounter on $chr for $SampleID"
#        else
#            echo "Could not run ASEReadCounter on $chr for $SampleID"
#            exit 1
#        fi
    fi
done

exit $?

