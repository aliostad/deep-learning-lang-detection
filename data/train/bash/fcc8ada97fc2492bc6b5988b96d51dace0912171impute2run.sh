#!/bin/bash
#$ -cwd



# Chromosome in question
CHR=$1
CHUNK_START=$(printf "%.0f" $2)
CHUNK_END=$(printf "%.0f" $3)
# filename=$4
# study sample gen file name
FILENAME=ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes

## directories
# root directory for IMPUTE2
ROOT_DIR=./
# data directories
DATA_DIR=../data/
# reference directory
REF_DIR='/home/rexren/KGBIG/impReference/1000genomes/1000GP_Phase3/'
# results directory
RESULTS_DIR=${ROOT_DIR}results/

## executable (must be IMPUTE version 2.2.0 or later)
IMPUTE2_EXEC=${ROOT_DIR}impute_v2.3.1_x86_64_dynamic/impute2

## parameters
NE=20000
# LINE_NUM=$(cat 22_dm_23andme_v3_110219.gen | wc -l)

## reference data files
GENMAP_FILE=${REF_DIR}genetic_map_chr${CHR}_combined_b37.txt
HAPS_FILE=${REF_DIR}1000GP_Phase3_chr${CHR}.hap.gz
LEGEND_FILE=${REF_DIR}1000GP_Phase3_chr${CHR}.legend.gz 
 
# haplotypes from shapeit
PHASED_HAPS_FILE=${DATA_DIR}${FILENAME}_23ANDME.phased.haps
# main output file
OUTPUT_FILE=${RESULTS_DIR}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.impute2

 
 
## impute genotypes from phased haplotypes
$IMPUTE2_EXEC \
   -use_prephased_g \
   -known_haps_g $PHASED_HAPS_FILE \
   -m $GENMAP_FILE \
   -h $HAPS_FILE \
   -l $LEGEND_FILE \
   -Ne $NE \
   -int $CHUNK_START $CHUNK_END \
   -o $OUTPUT_FILE \
   -allow_large_regions \
   # -phase

#
#
# $IMPUTE2_EXEC \
# 	-use_prephased_g \
#    -m $GENMAP_FILE \
#    -known_haps_g $GWAS_HAPS_FILE \
#    -h $HAPS_FILE \
#    -l $LEGEND_FILE \
#    -Ne $NE \
#    -int $CHUNK_START $CHUNK_END \
#    -o $OUTPUT_FILE \
#    -allow_large_regions \
#    -phase