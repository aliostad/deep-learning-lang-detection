#!/bin/bash

# autoStampy.sh
# Calls stampy on all sequence data in the directory provided
# Specify:path to files, location of reference, and location to write .sam files



#Example paths
#FILES=/data/maggie.bartkowska/spirodela_ma/all_raw_reads/GP2-3ABCD/*R1.fastq.gz
#REF=/data/maggie.bartkowska/spirodela_ma/reference/pseudo_plastids
#OUTLOC=/data/maggie.bartkowska/spirodella_ma/all_stampy_out/GP2-3A-H

echo "Enter directory containing sequence files (ex. /raw_reads/): "
read FILES

echo "Enter location of reference: (ex. /reference/pseudo_plastids)"
read REF

echo "Enter output directory: (ex. /all_stampy_out/CC3-3A-H/)"
read OUTLOC


#loop over every file that ends in R1.fastq.gz
for sampleNameR1 in $FILES*R1.fastq.gz
do
    echo "$sampleNameR1"
    #extract sample name (ex. 'GP2-3_F')
    sampleName="${sampleNameR1#*Index_}"
    sampleName="${sampleName#*.}"
    sampleName="${sampleName%%_R1.fastq*}"
    
    #Create name for R2 read	
    sampleNameR2="${sampleNameR1/R1/R2}"

   #     echo "call /data/wei.wang/stampy-1.0.23/stampy.py -t 6 \
#-g $REF \
#-h $REF \
#-M $sampleNameR1 \
#$sampleNameR2 >\
# $OUTLOC$sampleName.sam \
#2>$OUTLOC$sampleName.err &"


/data/wei.wang/stampy-1.0.23/stampy.py -t 6 \
-g $REF \
-h $REF \
-M $sampleNameR1 \
$sampleNameR2 >\
$OUTLOC$sampleName.sam \
2>$OUTLOC$sampleName.err &
#
done

