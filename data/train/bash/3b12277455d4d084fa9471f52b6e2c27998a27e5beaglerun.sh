# BEAGLE Imputation

# 23andme SNPs file name
CHR=$1
CHUNK_START=$(printf "%.0f" $2)
CHUNK_END=$(printf "%.0f" $3)

FILENAME=ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes

# directories
# root directory for BEAGLE
ROOT_DIR=./
# data directories
DATA_DIR=../data/
# reference directory
REF_DIR='/home/rexren/KGBIG/impReference/1000genomes/1000GP_Phase3/'
# results directory
RESULTS_DIR=${ROOT_DIR}results/

# BEAGLE executable (must be 1.9 or above)
BEAGLE_EXEC='java -jar ./beagle.r1398.jar'
# CONFORM-GT executable
# CONFORM_EXEC='java -jar ./conform-gt.jar'
# input vcf file
INPUT_VCF_FILE=${DATA_DIR}${FILENAME}_23ANDME.vcf
# reference vcf file
REF_VCF_FILE=${REF_DIR}${FILENAME}.vcf.gz

CORE=$(grep -c processor /proc/cpuinfo)


# output filename
OUTPUT_FILE=${RESULTS_DIR}${FILENAME}.pos${CHUNK_START}-${CHUNK_END}.BEAGLE


# # run conform
# $CONFORM_EXEC ref=$REF_VCF_FILE \
# 				gt=$INPUT_VCF_FILE \


# run beagle
$BEAGLE_EXEC ref=$REF_VCF_FILE \
				gtgl=$INPUT_VCF_FILE \
				usephase=true \
				nthreads=$CORE \
				chrom=$CHR:$CHUNK_START-$CHUNK_END \
				out=$OUTPUT_FILE

# $BEAGLE_EXEC ref=$REF_VCF_FILE \
# 				gtgl=$INPUT_VCF_FILE \
# 				usephase=true \
# 				nthreads=$CORE \
# 				out=${RESULTS_DIR}${FILENAME}.BEAGLE
