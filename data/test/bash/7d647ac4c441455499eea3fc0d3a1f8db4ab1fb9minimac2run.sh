 # MINIMACH Imputation

# 23andme SNPs file name
CHR=$1
CHUNK_START=$(printf "%.0f" $2)
CHUNK_END=$(printf "%.0f" $3)
# BUFFER=250000
# CHR=22
# CHUNK_START=20400000
# CHUNK_END=20500000
FILENAME=ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes

# directories
# root directory for MINIMACH
ROOT_DIR=./
# data directories
DATA_DIR=../data/
# reference directory
REF_DIR='/home/rexren/KGBIG/impReference/1000genomes/1000GP_Phase3/'
# results directory
RESULTS_DIR=${ROOT_DIR}results/

# MINIMACH executable (must be 1.9 or above)
MINIMACH_EXEC=${ROOT_DIR}minimac2/bin/minimac2
# input SNPs file
# INPUT_SNP_FILE=${DATA_DIR}${FILENAME}_23ANDME.pos${CHUNK_START}-${CHUNK_END}.prephasing.impute2.snps.gz
# INPUT_SNP_FILE=${DATA_DIR}${FILENAME}_23ANDME.phased.snps.gz
# input HAPS file
# INPUT_HAP_FILE=${DATA_DIR}${FILENAME}_23ANDME.pos${CHUNK_START}-${CHUNK_END}.prephasing.impute2_haps.gz
INPUT_SHAPE_HAP_FILE=${DATA_DIR}${FILENAME}_23ANDME.phased.haps
INPUT_SHAPE_SAMPLE_FILE=${DATA_DIR}${FILENAME}_23ANDME.phased.sample
# reference vcf file
REF_VCF_FILE=${REF_DIR}${FILENAME}.vcf.gz


# output filename
OUTPUT_FILE=${RESULTS_DIR}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.MACH

# impute
$MINIMACH_EXEC --vcfReference --refHaps $REF_VCF_FILE \
				--sample $INPUT_SHAPE_SAMPLE_FILE \
				--shape_haps $INPUT_SHAPE_HAP_FILE \
				--chr $CHR \
				--vcfstart $CHUNK_START \
				--vcfend $CHUNK_END \
				--rounds 5 \
				--states 200 \
				--prefix $OUTPUT_FILE

# $MINIMACH_EXEC --vcfReference --refHaps $REF_VCF_FILE --sample $INPUT_SHAPE_SAMPLE_FILE --shape_haps $INPUT_SHAPE_HAP_FILE --chr $CHR --vcfstart $CHUNK_START --vcfend $CHUNK_END --vcfwindow --rounds 5 --states 200 --prefix $OUTPUT_FILE

			
# $MINIMACH_EXEC --vcfReference --refHaps $REF_VCF_FILE --rs --snps $INPUT_SNP_FILE --haps $INPUT_HAP_FILE --vcfstart $CHUNK_START --vcfend $CHUNK_END --rounds 5 --states 200 --prefix $OUTPUT_FILE
# $MINIMACH_EXEC --vcfReference --refHaps $REF_VCF_FILE --rs --snps $INPUT_SNP_FILE --haps $INPUT_HAP_FILE --rounds 5 --states 200 --prefix $OUTPUT_FILE






 # minimac2 --vcfReference --refHaps ref.vcf.gz --haps target.hap.gz --snps target.snps.gz --rounds 5 --states 200 --prefix OUTPUT_FILE
