if [ $# -lt 4 ]
then
	echo -e "Usage:\n\tbash $0 <R1.fastq.gz> <R2.fastq.gz> <outdir> <sampleID>"
	exit 0
fi

read1=$1
read2=$2
outdir=$3
sampleID=$4
sampleID1=`echo $read1 | sed 's/.*\/\(.*\).fastq.gz/\1/;s/.*\(.*\).fastq/\1/'`
sampleID2=`echo $read2 | sed 's/.*\/\(.*\).fastq.gz/\1/;s/.*\(.*\).fastq/\1/'`
refdir="/home/oralCancer"

echo "read1: $read1"
echo "read2: $read2"
echo "outdir: $outdir"
echo "sampleID: $sampleID"
echo "sampleID1: $sampleID1"
echo "sampleID2: $sampleID2"
echo "refdir: $refdir"

/home/wipro/test-fresh/bin/cuda aln $refdir/hg19_GATK_Ref.fa $read1 > $outdir/$sampleID1.sai
/home/wipro/test-fresh/bin/cuda aln $refdir/hg19_GATK_Ref.fa $read2 > $outdir/$sampleID2.sai

/home/wipro/test-fresh/bin/cuda sampe $refdir/hg19_GATK_Ref.fa $outdir/$sampleID1.sai $outdir/$sampleID2.sai $read1 $read2 > $outdir/$sampleID.sam
samtools view -bS $outdir/$sampleID.sam > $outdir/$sampleID.bam
samtools sort $outdir/$sampleID.bam $outdir/$sampleID.sorted
samtools index $outdir/$sampleID.sorted.bam
