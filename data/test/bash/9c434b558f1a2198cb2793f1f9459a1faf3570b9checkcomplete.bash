# Requires SAMPLE_NAME and GENOME to be in the environment
# Checks that important files exist and are not size 0

EXIT=0

files=( \
    "${SAMPLE_NAME}.sorted.bam" \ 
    "${SAMPLE_NAME}.sorted.bam.bai" \ 
    "${SAMPLE_NAME}.R1.rand.uniques.sorted.spotdups.txt" \
    "${SAMPLE_NAME}.R1.rand.uniques.sorted.spot.out" \
    "${SAMPLE_NAME}.tagcounts.txt" \
    "${SAMPLE_NAME}.versions.txt" \
    "${SAMPLE_NAME}.CollectInsertSizeMetrics.picard" \
    "${SAMPLE_NAME}.MarkDuplicates.picard" \
    "${SAMPLE_NAME}.75_20.${GENOME}.bw" \
)

for FILE in "${files[@]}"; do
if [ ! -s $FILE ]; then
    echo "Missing $FILE"
    EXIT=1
fi
done

exit $EXIT
