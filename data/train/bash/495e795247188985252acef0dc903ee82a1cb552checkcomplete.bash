# Requires SAMPLE_NAME and GENOME to be in the environment
# Checks that important files exist and are not size 0

EXIT=0

files=( \
    "${SAMPLE_NAME}.adapters.txt" \
    "${SAMPLE_NAME}.all.${GENOME}.bam" \
    "${SAMPLE_NAME}.all.${GENOME}.bam.bai" \
    "${SAMPLE_NAME}.all.${GENOME}.bw" \
    "${SAMPLE_NAME}.all.${GENOME}.starch" \
    "${SAMPLE_NAME}.neg.${GENOME}.bam" \
    "${SAMPLE_NAME}.neg.${GENOME}.bam.bai" \
    "${SAMPLE_NAME}.neg.${GENOME}.bw" \
    "${SAMPLE_NAME}.neg.${GENOME}.starch" \
    "${SAMPLE_NAME}.pos.${GENOME}.bam" \
    "${SAMPLE_NAME}.pos.${GENOME}.bam.bai" \
    "${SAMPLE_NAME}.pos.${GENOME}.bw" \
    "${SAMPLE_NAME}.pos.${GENOME}.starch" \
    "${SAMPLE_NAME}.bam_counts.txt" \
    "${SAMPLE_NAME}.read_counts.txt" \
    "${SAMPLE_NAME}.rRNAcounts.txt" \
    "${SAMPLE_NAME}.sample_summary.txt" \
    "${SAMPLE_NAME}.spotdups.txt" \
    "picard.${SAMPLE_NAME}.AlignmentSummary.txt" \
    "picard.${SAMPLE_NAME}.InsertSize.txt" \
    "picard.${SAMPLE_NAME}.RnaSeq.txt" \
    "${SAMPLE_NAME}_cufflinks/genes.fpkm_tracking" \
    "${SAMPLE_NAME}_cufflinks/isoforms.fpkm_tracking" \
    "${SAMPLE_NAME}_cufflinks/transcripts.gtf" \
)

for FILE in "${files[@]}"; do
if [ ! -s $FILE ]; then
    echo "Missing $FILE"
    EXIT=1
fi
done

exit $EXIT
