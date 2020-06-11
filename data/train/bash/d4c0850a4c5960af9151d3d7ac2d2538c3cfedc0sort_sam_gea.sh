#!/bin/bash


DIR=/home/rgarcia/MCAC/sam
ADDORREPLACEREADGROUPS=/home/rgarcia/downloads/picard-tools-1.121/AddOrReplaceReadGroups.jar
 
for SAMPLE in $(seq -f "%02g" 1 49)
do
    samtools sort -o $DIR/gea/S${SAMPLE}.bam \
	     -O bam -T $DIR -@ 30 -m 8G $DIR/gea/S${SAMPLE}.sam



    BAM=$DIR/gea/S${SAMPLE}.bam
    BAMOUT=$DIR/gea/S${SAMPLE}_rg.bam
    java -jar $ADDORREPLACEREADGROUPS \
                 I=$BAM \
                 LB='mcac' \
                 PL='ion' \
                 PU='nil' \
                 SM=$SAMPLE \
                 O=$BAMOUT
    
done

