# Environment variables expected:
#
# * SAMPLE_NAME: the "base name" of the FASTQ files
# * CHUNK_SIZE: optionally change the chunk size from 16,000,000
#
# Requires the pigz module to be loaded

FASTQ_TMP=$1
R1_FASTQ=$2
R2_FASTQ=$3
CHUNK_SIZE="${CHUNK_SIZE:-16000000}"

LINE_CHUNK=$(($CHUNK_SIZE * 4))

if [[ -e $FASTQ_TMP ]]; then
  rm -rf $FASTQ_TMP/${SAMPLE_NAME}_R?_???.fastq.gz
fi

mkdir -p $FASTQ_TMP

echo "Splitting FASTQ files into $CHUNK_SIZE reads using $TMPDIR"
date

echo "Splitting $R1_FASTQ"
zcat $R1_FASTQ | split -l $LINE_CHUNK -d -a 3 - "$TMPDIR/${SAMPLE_NAME}_R1_"
date

if [ -n $R1_FASTQ ]; then
  echo "Splitting $R2_FASTQ"
  zcat $R2_FASTQ | split -l $LINE_CHUNK -d -a 3 - "$TMPDIR/${SAMPLE_NAME}_R2_"
  date
fi

SPLIT_COUNT=`ls $TMPDIR/${SAMPLE_NAME}_R1_??? | wc -l`

if [ "$SPLIT_COUNT" -eq 1 ]; then
    # We only have one file split
    # Don't bother compressing again, just symlink the existing full fastq files
    echo "Files do not exceed $CHUNK_SIZE; symlinking original files"
    ln -s $R1_FASTQ $FASTQ_TMP/${SAMPLE_NAME}_R1_000.fastq.gz
    if [ -n $R1_FASTQ ]; then
      ln -s $R2_FASTQ $FASTQ_TMP/${SAMPLE_NAME}_R2_000.fastq.gz
    fi
    exit
fi

for RAW_FILE in `find ${TMPDIR} -name "${SAMPLE_NAME}_R?_???"`; do
    echo "Compressing ${RAW_FILE}"
    date
    mv $RAW_FILE ${RAW_FILE}.fastq
    FASTQ_FILENAME=`basename $RAW_FILE`
    pigz --fast -p 2 -c ${RAW_FILE}.fastq > $FASTQ_TMP/$FASTQ_FILENAME.fastq.gz
done

echo "Done compressing"
date
