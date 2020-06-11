#!/bin/bash

# assign inputs
GWAS_DATA=SYounkin_MayoGWAS_09-05-08

# directories
S3_BUCKET=s3://mayo-gwas-impute/
DATA_DIR=/mnt/data/

if [ ! -e "$DATA_DIR" ]; then
    mkdir "$DATA_DIR"
fi

GWAS_DIR=gwas_results/${GWAS_DATA}.b37/
GWAS_IMP_DIR=gwas_results/${GWAS_DATA}.imputed/
INTS_DIR=${GWAS_DIR}impute_intervals/

# get list of imputed files on S3
S3_INTS_LIST=`mktemp s3-ints.XXX`
aws s3 ls ${S3_BUCKET}${GWAS_IMP_DIR} \
    | awk '{print $4}' \
    > $S3_INTS_LIST

for CHR in $(seq 1 22); do

    INTS_FILE="${INTS_DIR}chr${CHR}.ints"

    # get impute interval ranges from S3
    aws s3 cp \
        ${S3_BUCKET}${INTS_FILE} \
        ${DATA_DIR}${INTS_FILE}

    NUM_INTS=$(expr $(wc -l ${DATA_DIR}${INTS_FILE} | awk '{print $1}') - 1)

    for INT in $(seq 1 $NUM_INTS); do

        CHUNK_START=$(awk -v i=$INT '$3==i {print $5}' ${DATA_DIR}${INTS_FILE})
        CHUNK_END=$(awk -v i=$INT '$3==i {print $6}' ${DATA_DIR}${INTS_FILE})

        INT_CHECK=chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.imputed$
        if ! grep -q $INT_CHECK $S3_INTS_LIST; then
            echo $INT_CHECK
            qsub -S /bin/bash -V -cwd -M james.a.eddy@gmail.com -m abe -j y \
                -N re_impute_chr${CHR}_int${INT}${CHUNK_START}-${CHUNK_END} \
                shell/impute.sh $GWAS_DATA $CHR $CHUNK_START $CHUNK_END ;
        fi

    done

done

rm $S3_INTS_LIST
