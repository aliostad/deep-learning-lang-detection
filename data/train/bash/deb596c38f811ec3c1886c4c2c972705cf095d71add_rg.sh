#!/bin/bash

DIR=/home/rgarcia/MCAC/sam
ADDORREPLACEREADGROUPS=/home/rgarcia/downloads/picard-tools-1.121/AddOrReplaceReadGroups.jar

# for SAMPLE in $(seq -f "%02g" 1 48)           
# do
#     BAM=$DIR/300/S${SAMPLE}.bam
#     BAMOUT=$DIR/300/S${SAMPLE}_rg.bam
#     java -jar $ADDORREPLACEREADGROUPS \
#                  I=$BAM \
#                  LB='mcac' \
#                  PL='illumina' \
#                  PU='nil' \
#                  SM=$SAMPLE \
#                  O=$BAMOUT

# done


# for SAMPLE in $(seq -f "%02g" 1 48)           
# do
#     BAM=$DIR/500/S${SAMPLE}.bam
#     BAMOUT=$DIR/500/S${SAMPLE}_rg.bam
#     java -jar $ADDORREPLACEREADGROUPS \
#                  I=$BAM \
#                  LB='mcac' \
#                  PL='illumina' \
#                  PU='nil' \
#                  SM=$SAMPLE \
#                  O=$BAMOUT

# done




# MAU29="S17.aqm
# S26.MGV
# S18.IXH
# S22.CYDR
# S24.MRMT
# S20.CEV
# S19.CFOG
# S23.MEAR
# S21.PAHH
# S25.MCV"

# for SAMPLE in $MAU29
# do
#     BAM=$DIR/mau29/${SAMPLE}.bam
#     BAMOUT=$DIR/mau29/${SAMPLE}_rg.bam
#     java -jar $ADDORREPLACEREADGROUPS \
#                  I=$BAM \
#                  LB='mcac' \
#                  PL='ion' \
#                  PU='nil' \
#                  SM=$SAMPLE \
#                  O=$BAMOUT &
# done
         







# EXM_ILLIMINA="DLA
# GEL
# GMCA
# JLRL
# JLRM
# LMG
# PTL
# YRN"

# for SAMPLE in $EXM_ILLIMINA
# do
#     BAM=$DIR/exm_illumina/${SAMPLE}.bam
#     BAMOUT=$DIR/exm_illumina/${SAMPLE}_rg.bam
#     java -jar $ADDORREPLACEREADGROUPS \
#                  I=$BAM \
#                  LB='mcac' \
#                  PL='exm_illumina' \
#                  PU='nil' \
#                  SM=$SAMPLE \
#                  O=$BAMOUT &
# done
         


for SAMPLE in $(seq -f "%02g" 1 17)           
do
    BAM=$DIR/exm_caem_fvi_rigo/S${SAMPLE}.bam
    BAMOUT=$DIR/exm_caem_fvi_rigo/S${SAMPLE}_rg.bam
    java -jar $ADDORREPLACEREADGROUPS \
                 I=$BAM \
                 LB='mcac' \
                 PL='illumina' \
                 PU='nil' \
                 SM=$SAMPLE \
                 O=$BAMOUT
done
