#PBS -l nodes=1:ppn=8,mem=6gb,walltime=48:00:00 -j oe -N bwa
module load bwa/0.7.9
module load samtools/1.1
module load java
module load picard

CPU=$PBS_PPN
SAMPLEFILE=samples.info
BWA=bwa
GENOMEIDX=/shared/stajichlab/projects/Hortea/assemblies/current/Hw_016457.fa
OUTPUT=bam
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
#INDIR=`dirname $READ1`
INDIR=Sample

echo "SAMPLE=$SAMPLE"
echo "R1=$READ1 R2=$READ2"

if [ ! -f $OUTPUT/$SAMPLE.bam ]; then

 if [ ! -f $OUTPUT/$SAMPLE.sam ]; then
     $BWA mem -t $CPU $GENOMEIDX $INDIR/$SAMPLE.1.fq $INDIR/$SAMPLE.2.fq > $OUTPUT/$SAMPLE.sam
 fi

 java -jar $PICARD/SortSam.jar I=$OUTPUT/$SAMPLE.sam O=$OUTPUT/$SAMPLE.bam SO=coordinate CREATE_INDEX=TRUE
fi
if [ ! -f $OUTPUT/$SAMPLE.RG.bam ]; then
java -jar $PICARD/AddOrReplaceReadGroups.jar I=$OUTPUT/$SAMPLE.bam O=$OUTPUT/$SAMPLE.RG.bam RGLB=$SAMPLE RGID=$SAMPLE RGSM=$SAMPLE RGPL=illumina RGPU=$SAMPLE RGCN=UBC RGDS="$READ1 $READ2" 
echo "mv $OUTPUT/$SAMPLE.RG.bam $OUTPUT/$SAMPLE.bam"

fi

