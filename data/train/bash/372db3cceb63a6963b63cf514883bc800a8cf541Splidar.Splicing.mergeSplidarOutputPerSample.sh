#!/bin/bash

#sample

scriptDir=$1
rootDir=$2
sample=$3
genome=$4
TAB=`echo -e "\t"`



echo "merging sample $sample" > /dev/stderr

cd $rootDir

cd $sample


rm -f *.00




cat $sample.*.exinc.xls > $sample.merged.headless.00 


sed -e "s/sampleLabel/$sample/ig" < $scriptDir/Splidar.Splicing.headerGeneric.txt > $sample.header.txt
UCSCLinkCol=`colSelect.py "$sample.header.txt" .UCSCGenomeBrowser`  


#correct the genome info here and make bed file

eventKeyStart=`colSelect.py $scriptDir/Splidar.Splicing.headerGeneric.txt .eventType`
eventKeyStart=`expr $eventKeyStart - 1`
eventKeyEnd=`colSelect.py $scriptDir/Splidar.Splicing.headerGeneric.txt .UCSCGenomeBrowser`
eventKeyEnd=`expr $eventKeyEnd - 1`


cut -d"$TAB" -f$eventKeyStart-$eventKeyEnd $sample.merged.headless.00 > $sample.eventKey.00

paste ../eventID.00 $sample.merged.headless.00  > $sample.merged.headless.wEID.00

#awk -F"\t" -v UCSCCol=$UCSCLinkCol -v GENOME=$genome 'BEGIN{FS="\t";OFS="\t"}{sub(/hg18/,GENOME,$UCSCCol); print;}' $sample.merged.headless.wEID.p.00 > $sample.merged.headless.wEID.00

cat $sample.header.txt $sample.merged.headless.wEID.00 > $sample.merged.xls

cd $scriptDir





