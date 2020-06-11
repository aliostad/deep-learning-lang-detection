# Requires SAMPLE_NAME and GENOME to be in the environment
# Removes any of the listed files that exist

echo "RESETTING ALIGNMENT FOR ${SAMPLE_NAME}"

files=( \
    "${SAMPLE_NAME}.sorted.bam" \ 
    "${SAMPLE_NAME}.sorted.bam.bai" \ 
    "${SAMPLE_NAME}.R1.rand.uniques.sorted.spotdups.txt" \
    "${SAMPLE_NAME}.R1.rand.uniques.sorted.spot.out" \
    "${SAMPLE_NAME}.tagcounts.txt" \
    "${SAMPLE_NAME}.sorted.bam" \
    "${SAMPLE_NAME}.sorted.bam.bai" \
    "${SAMPLE_NAME}.uniques.sorted.bam" \
    "${SAMPLE_NAME}.uniques.sorted.bam.bai" \
    "${SAMPLE_NAME}.versions.txt" \
    "${SAMPLE_NAME}.CollectInsertSizeMetrics.picard" \
    "${SAMPLE_NAME}.CollectInsertSizeMetrics.picard.pdf" \
    "${SAMPLE_NAME}.MarkDuplicates.picard" \
    "${SAMPLE_NAME}.75_20.uniques-density.${READLENGTH}.${GENOME}.bed.starch" \
    "${SAMPLE_NAME}.75_20.${GENOME}.bw" \
    "${SAMPLE_NAME}.adapters.txt" \
)

for FILE in "${files[@]}"; do
    if [ -e "$FILE" ]; then
        echo "Removing $FILE"
        rm $FILE
    fi
done

if [ -e "fastq" ]; then
    rm -r fastq
fi

# Remove all trim stat files

for FILE in `find . -name "${SAMPLE_NAME}.trimstats.txt"`; do
    echo "Removing $FILE"
    rm $FILE
done

# Delete old job file logs

prefixes=( \
     ".aln" \
     ".com" \
     ".ct" \
     ".den" \
     ".pb" \
     ".proc" \
     ".sp" \
)

for PREFIX in "${prefixes[@]}"; do
    for FILE in `find . -name "$PREFIX${SAMPLE_NAME}*${FLOWCELL}.*"`; do
        echo "Removing $FILE"
        rm $FILE
    done
done

python3 $STAMPIPES/scripts/lims/upload_data.py --clear_align_stats --alignment_id ${ALIGNMENT_ID}
