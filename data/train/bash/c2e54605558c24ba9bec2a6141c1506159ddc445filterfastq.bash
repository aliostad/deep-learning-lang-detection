# USAGE: bash $STAMPIPES/scripts/filterfastq.bash D14_WT_IgG_K4me3_IP_TGACCA_L004_R1

cd "$FASTQ_DIR"

echo FILTERING $SAMPLE_NAME

for fastq in $SAMPLE_NAME*.fastq.gz ; 
do

echo FILTERING $fastq

zcat $fastq | \
   awk '{if (substr($2, 3, 1) == "N") {f=0;print $1} else if (substr($2, 3, 1) == "Y") {f=1} else if ( f == 0) {print $1 } }' \
   > filtered_`basename $fastq .gz`;

done

for read in R1 R2 ; do
    echo COLLATING "$SAMPLE_NAME"_"$read" FASTQ
    cat filtered_"$SAMPLE_NAME"_"$read"*.fastq | gzip -c > filtered_"$SAMPLE_NAME"_"$read".fastq.gz
done
rm filtered_$SAMPLE_NAME*.fastq
