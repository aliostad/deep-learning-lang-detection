#!/bin/bash
#$ -cwd



# Chromosome in question
CHR=$1
CHUNK_START=$(printf "%.0f" $2)
CHUNK_END=$(printf "%.0f" $3)
# study sample gen file name
FILENAME=ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes_23ANDME
## directories
# root directory for IMPUTE2
ROOT_DIR=./
# data directories
DATA_DIR=${ROOT_DIR}data/
# reference directory
REF_DIR='/home/rexren/KGBIG/impReference/1000genomes/1000GP_Phase3/'
## executable (must be IMPUTE version 2.2.0 or later)
IMPUTE2_EXEC=${ROOT_DIR}IMPUTE2/impute_v2.3.1_x86_64_dynamic/impute2

## parameters
NE=20000
# LINE_NUM=$(cat 22_dm_23andme_v3_110219.gen | wc -l)

## reference data files
GENMAP_FILE=${REF_DIR}genetic_map_chr${CHR}_combined_b37.txt
 
# study data files
GWAS_GTYPE_FILE=${DATA_DIR}${FILENAME}.gen
 
# main output file
OUTPUT_FILE=${DATA_DIR}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.prephasing.impute2
 
## pre-phase GWAS genotypes
$IMPUTE2_EXEC \
    -prephase_g \
    -allow_large_regions \
    -m $GENMAP_FILE \
    -g $GWAS_GTYPE_FILE \
    -Ne $NE \
    -int $CHUNK_START $CHUNK_END \
    -o $OUTPUT_FILE
 
# get SNP file for minimac
sed 's/\(^[0-9a-Z]*\) \([0-9a-Z]*\) \([0-9a-Z]*\) \(.*$\)/\1:\3/g' ${OUTPUT_FILE}_haps > ${OUTPUT_FILE}.snps
gzip -c ${OUTPUT_FILE}.snps > ${OUTPUT_FILE}.snps.gz
gzip -c ${OUTPUT_FILE}_haps > ${OUTPUT_FILE}_haps.gz

