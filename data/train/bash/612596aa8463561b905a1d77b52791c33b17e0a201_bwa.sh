#PBS  -l nodes=1:ppn=32,mem=96gb -j oe -N bwa

module load bwa
module load samtools
module load java
module load picard

CPU=1
SAMPLEFILE=samples.info
BWA=bwa
GENOMEIDX=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/New_ref_assembly/ref/S9
OUTPUT=bam
QUAL=20

mkdir -p $OUTPUT

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
echo "CPU is $CPU"
LINE=$PBS_ARRAYID

if [ ! $LINE ]; then
 LINE=$1
fi

if [ ! $LINE ]; then 
 echo "Need a number via PBS_ARRAYID or cmdline"
 exit
fi

ROW=$(sed -n ${LINE}p $SAMPLEFILE)
SAMPLE=$(echo "$ROW" | awk '{print $1}')
READ1=$(echo "$ROW" | awk '{print $2}')
READ2=$(echo "$ROW" | awk '{print $3}')
INDIR=`dirname $READ1`
BARCODE=$(basename $(dirname $READ1))
echo "SAMPLE=$SAMPLE"
#echo "R1=$READ1 R2=$READ2"
#BARCODE=`head -n 1 $INDIR/$SAMPLE.1.fq | awk -F: '{print $1"."$2"."$3}' | perl -p -e 's/^\@//'`
#BARCODE=`basename $READ1 | perl -p -e 's/.+_([ACGT]+-[ACTG]+)_.+/$1/'`
echo "BARCODE=$BARCODE"

if [ ! -f $OUTPUT/$SAMPLE.DD.bam ]; then

if [ ! -f $OUTPUT/$SAMPLE.sam ]; then
  $BWA mem -t $CPU $GENOMEIDX $READ1 $READ2 > $OUTPUT/$SAMPLE.sam
fi

if [ ! -f $OUTPUT/$SAMPLE.RG.bam ]; then
 java -jar $PICARD AddOrReplaceReadGroups I=$OUTPUT/$SAMPLE.sam O=$OUTPUT/$SAMPLE.RG.bam RGLB=$SAMPLE RGID=$SAMPLE RGSM=$SAMPLE RGPL=illumina RGPU=$BARCODE RGCN=UCR_Cofactor CREATE_INDEX=true SO=coordinate
# rm $OUTPUT/$SAMPLE.sam
# touch $OUTPUT/$SAMPLE.sam
fi
 java -jar $PICARD MarkDuplicates I=$OUTPUT/$SAMPLE.RG.bam O=$OUTPUT/$SAMPLE.DD.bam METRICS_FILE=$SAMPLE.dedup.metrics CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT
fi
