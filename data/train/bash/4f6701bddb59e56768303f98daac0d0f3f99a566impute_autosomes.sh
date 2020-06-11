#!/bin/bash

CHR=$1
CHUNK_START=`printf "%.0f" $2`
CHUNK_END=`printf "%.0f" $3`
FILE=$4
OUTROOT=$5

PHASEDIR=${OUTROOT}prephased/
IMPUTEDIR=${OUTROOT}imputed/
PROCESSEDDIR=${OUTROOT}processed/

REFDIR=~/soft/ref1000G/
SAMPLE_FILE=${REFDIR}genetic_map_chr${CHR}_combined_b37.txt 

mkdir ${OUTROOT}imputed/
mkdir ${OUTROOT}processed/

IMPUTE=~/soft/impute/impute2
GTOOL=~/soft/gtool2/gtool
PLINK=~/soft/plink/plink

${IMPUTE} \
-use_prephased_g \
-m ${SAMPLE_FILE} \
-h ${REFDIR}ALL_1000G_phase1integrated_v3_chr${CHR}_impute.hap.gz \
-l ${REFDIR}ALL_1000G_phase1integrated_v3_chr${CHR}_impute.legend.gz \
-sample_g ${PHASEDIR}${FILE}_chr${CHR}.sample \
-known_haps_g ${PHASEDIR}${FILE}_chr${CHR}.prephased.haps.gz \
-Ne 20000 \
-int ${CHUNK_START} ${CHUNK_END} \
-o ${IMPUTEDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.impute2 \
-o_gz \
-verbose \
-allow_large_regions

## GEN to PED
${GTOOL} \
-G --chr ${CHR} \
--phenotype plink_pheno \
--g ${IMPUTEDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.impute2.gz \
--s ${IMPUTEDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.impute2_samples \
--ped ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.ped.gz \
--map ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.map.gz
		
gunzip ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.ped.gz
gunzip ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.map.gz
		
## PED to BED
${PLINK} \
--file ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed \
--make-bed  \
--maf 0.0001 \
--out ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed
					
rm ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.ped
rm ${PROCESSEDDIR}${FILE}_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed.map
