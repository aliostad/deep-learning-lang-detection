#PBS -l nodes=1:ppn=8,mem=32gb -j oe -N bwa

module load bwa
module load samtools
module load java
module load picard

hostname

CPU=$PBS_PPN
SAMPLEFILE=samples.info
BWA=bwa
GENOMEIDX=/bigdata/stajichlab/shared/projects/HMAC/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC_42720.fasta
OUTPUT=bam_ATCC_bwa-aln
QUAL=20

mkdir -p $OUTPUT

if [ ! $CPU ]; then
 CPU=1
fi

LINE=$PBS_ARRAYID

if [ ! $LINE ]; then
 LINE=$1
fi

if [ ! $LINE ]; then 
 echo "Need a number via PBS_ARRAYID or cmdline"
 exit
fi

ROW=`head -n $LINE $SAMPLEFILE | tail -n 1`
SAMPLE=`echo "$ROW" | awk '{print $1}'`
READ1=`echo "$ROW" | awk '{print $2}'`
READ2=`echo "$ROW" | awk '{print $3}'`
INDIR=`dirname $READ1`

echo "SAMPLE=$SAMPLE"
echo "R1=$READ1 R2=$READ2"
BARCODE=`basename $READ1 | perl -p -e 's/.+_([ACGT]+-[ACTG]+)_.+/$1/'`
echo "BARCODE=$BARCODE"

if [ ! -f $OUTPUT/$SAMPLE.DD.bam ]; then

 if [ ! -f $OUTPUT/$SAMPLE.sam ]; then
     $BWA aln -t $CPU -f $OUTPUT/$SAMPLE.1.sai $GENOMEIDX $INDIR/$SAMPLE.1.fq 
     $BWA aln -t $CPU -f $OUTPUT/$SAMPLE.2.sai $GENOMEIDX $INDIR/$SAMPLE.2.fq
     $BWA sampe -f $OUTPUT/$SAMPLE.sam $GENOMEIDX $OUTPUT/$SAMPLE.1.sai $OUTPUT/$SAMPLE.2.sai $INDIR/$SAMPLE.1.fq $INDIR/$SAMPLE.2.fq
 fi

if [ ! -f $OUTPUT/$SAMPLE.RG.bam ]; then
 java -jar $PICARD AddOrReplaceReadGroups I=$OUTPUT/$SAMPLE.sam O=$OUTPUT/$SAMPLE.RG.bam RGLB=$SAMPLE RGID=$SAMPLE RGSM=$SAMPLE RGPL=illumina RGPU=$BARCODE RGCN=UCR_Cofactor RGDS="$READ1 $READ2" CREATE_INDEX=true SO=coordinate VALIDATION_STRINGENCY=SILENT # IGNORE=INVALID_MAPPING_QUALITY
fi

 java -jar $PICARD MarkDuplicates I=$OUTPUT/$SAMPLE.RG.bam O=$OUTPUT/$SAMPLE.DD.bam METRICS_FILE=$SAMPLE.dedup.metrics CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT
fi
