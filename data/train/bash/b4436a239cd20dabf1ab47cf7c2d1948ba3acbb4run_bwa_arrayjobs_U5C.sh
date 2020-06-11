#PBS  -l nodes=1:ppn=32,mem=96gb -j oe -N bwa

module load bwa/0.7.9
module load samtools/1.1
module load java
module load picard

CPU=$PBS_NUM_PPN
SAMPLEFILE=samples.info
BWA=bwa
GENOMEIDX=/shared/stajichlab/projects/Candida/HMAC/Clus_reseq/Aln/U5C_Ref/candida_lusitaniae_U5C.fasta
OUTPUT=bam_U5C
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
     $BWA mem -t $CPU $GENOMEIDX $INDIR/$SAMPLE.1.fq $INDIR/$SAMPLE.2.fq > $OUTPUT/$SAMPLE.sam
 fi
 #java -jar $PICARD/SortSam.jar I=$OUTPUT/$SAMPLE.sam O=$OUTPUT/$SAMPLE.bam SO=coordinate CREATE_INDEX=TRUE

if [ ! -f $OUTPUT/$SAMPLE.RG.bam ]; then
 java -jar $PICARD/AddOrReplaceReadGroups.jar I=$OUTPUT/$SAMPLE.sam O=$OUTPUT/$SAMPLE.RG.bam RGLB=$SAMPLE RGID=$SAMPLE RGSM=$SAMPLE RGPL=illumina RGPU=$BARCODE RGCN=UCR_Cofactor RGDS="$READ1 $READ2" CREATE_INDEX=true SO=coordinate
fi

 java -jar $PICARD/MarkDuplicates.jar I=$OUTPUT/$SAMPLE.RG.bam O=$OUTPUT/$SAMPLE.DD.bam METRICS_FILE=$SAMPLE.dedup.metrics CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT
fi
