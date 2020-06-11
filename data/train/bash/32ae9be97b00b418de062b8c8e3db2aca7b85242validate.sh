## Validation to measure performance


#!/bin/bash
#$ -cwd

# Prep data for imputation

# Inpute Parameters 
# 23andme filename
if [ -z $1 ]
then
	ME_NAME='hu500536'
else
	ME_NAME=$1
fi
# Chromosome
if [ -z $2 ]
then
	CHR=22
else
	CHR=$2
fi
# START Position
if [ -z $3 ]
then
	CHUNK_START=20400000
else
	CHUNK_START=$(printf "%.0f" $3)
fi
# END Position
if [ -z $4 ]
then
	CHUNK_END=20500000
else
	
	CHUNK_END=$(printf "%.0f" $4)
fi
# # convert 23andme to gen
# sh ./convert.sh $ME_NAME $CHR
# # extract 23andme SNPs from target file
# sh ./extract.sh $CHR
# # prephasing
# # sh ./pre-phasing.sh $CHR $CHUNK_START $CHUNK_END
# haplotyping
# sh ./hap.sh $CHR






FILENAME=ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes

## directories
# root directory for IMPUTE2
ROOT_DIR=./
# data directories
DATA_DIR=${ROOT_DIR}data/
# reference directory
REF_DIR='/home/rexren/KGBIG/impReference/1000genomes/1000GP_Phase3/'
# results directory
RESULTS_DIR=${ROOT_DIR}results/
# helper directory
HELP_DIR=${ROOT_DIR}helper/
# IMPUTE2 RESULTS
IMPUTE2_RESULTS=${ROOT_DIR}IMPUTE2/results/
# BEAGLE RESULTS
BEAGLE_RESULTS=${ROOT_DIR}BEAGLE/results/
# MACH RESULTS
MACH_RESULTS=${ROOT_DIR}MACH/results/


# PLINK executable (must be 1.9 or above)
PLINK_EXEC=${HELP_DIR}plink/plink
# BCFTOOL exec
BCFTOOL_EXEC=${HELP_DIR}bcftools/bcftools
# BGZIP exec
BGZIP_EXEC=${HELP_DIR}htslib/./bgzip
# Tabix exec
TABIX_EXEC=${HELP_DIR}htslib/./tabix
# vcftools
VCFTOOL_EXEC=${HELP_DIR}vcftools/bin/./vcftools
# input files
ORIGINAL_FILE=${DATA_DIR}${FILENAME}

# BEAGLE imputed file
BEAGLE_IMPUTED=${BEAGLE_RESULTS}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.BEAGLE
# IMPUTE2 imputed file
IMPUTE2_IMPUTED=${IMPUTE2_RESULTS}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.impute2
# MACH imputed file
MACH_IMPUTED=${MACH_RESULTS}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.MACH

# range in kilo base pair units
# 
STARTKB=$(( CHUNK_START / 1000 ))
ENDKB=$(( CHUNK_END / 1000 ))

# convert original file to vcf
$PLINK_EXEC --vcf ${ORIGINAL_FILE}.vcf.gz --chr ${CHR} --from-kb $STARTKB --to-kb $ENDKB --snps-only no-DI --recode vcf --out ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original


# convert BEAGLE OUTPUT_FILE to vcf
$PLINK_EXEC --vcf ${BEAGLE_IMPUTED}.vcf.gz --chr ${CHR} --from-kb $STARTKB --to-kb $ENDKB --snps-only no-DI --recode vcf --out ${BEAGLE_IMPUTED}

# # use bgzip and tabix so bcftool can be used 
# $BGZIP_EXEC ${BEAGLE_IMPUTED}.vcf
# $TABIX_EXEC -p vcf ${BEAGLE_IMPUTED}.vcf.gz

# $BGZIP_EXEC ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original.vcf
# $TABIX_EXEC -p vcf ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original.vcf.gz





# $VCFTOOL_EXEC --vcf ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original.vcf --diff ${BEAGLE_IMPUTED}.vcf --diff-site --out ${BEAGLE_IMPUTED}

# $VCFTOOL_EXEC --vcf ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original.vcf --diff ${BEAGLE_IMPUTED}.vcf --diff-site-discordance --out ${BEAGLE_IMPUTED}

$VCFTOOL_EXEC --vcf ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original.vcf --diff ${BEAGLE_IMPUTED}.vcf  --diff-indv-discordance --out ${BEAGLE_IMPUTED}

### calculate average concordance rate for each individual. by summming up all (1-discordance rate) for each individual and them divide by number_ind

# avg by individuals,total individual number -1 because there is one line of header
BEAGLE_CONCOR="$(cat ${BEAGLE_IMPUTED}.diff.indv| awk '{tot_concor+=1-$4; tot_ind+=1; } END {tot_ind-=1; print tot_concor/tot_ind }')"

# avg by snps, total individual number -1 because there is one line of header
MACH_CONCOR="$(cat ${MACH_IMPUTED}.erate | awk '{tot_concor+=1-$2; tot_ind+=1; } END {tot_ind-=1; print tot_concor/tot_ind }')"

# avg by individuals, total individual number -1 because there is one line of header
IMPUTE2_CONCOR="$(cat ${IMPUTE2_IMPUTED}_info_by_sample | awk '{tot_concor+=$1; tot_ind+=1; } END { tot_ind-=1; print tot_concor/tot_ind }')"

# # Compare BEAGLE and Original output WITH BCFTOOLS
# $BCFTOOL_EXEC gtcheck -a -g ${ORIGINAL_FILE}.pos${CHUNK_START}-${CHUNK_END}.original.vcf.gz ${BEAGLE_IMPUTED}.vcf.gz -p ${BEAGLE_IMPUTED}.validation
# 

