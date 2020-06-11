
# 
echo 'Written to auto-trim the reads using illumina adaptors, in case of read contamination.
	usage autotrim <fastq_dir> <output_dir> <yes/no>'

seqdir=${1}
workdir=${2}

cd $workdir
array=$(ls $seqdir | grep R1.fastq)
for dat in $array
do
sample=$(basename $dat _R1.fastq.gz)
echo 'trimming sample' "${sample}"
java -jar ~/programs/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads 30 -phred33 \
${seqdir}/${sample}_R1.fastq.gz \
${seqdir}/${sample}_R2.fastq.gz \
${workdir}/${sample}_R1.fastq.gz \
${workdir}/${sample}_unpaired_R1.fastq.gz \
${workdir}/${sample}_R2.fastq.gz \
${workdir}/${sample}_unpaired_R2.fastq.gz \
ILLUMINACLIP:Truseq_adapters_all.fa:4:30:15 MINLEN:36
done


# fastqc of trimmed reads
mkdir $workdir/fastqc
newarray=$(ls $workdir | grep R1.fastq)
for data in $newarray
do
sample=$(basename $data _R1.fastq.gz)
echo 'Performing fastqc for ' "$sample"
~/programs/fastQC_0.11/fastqc ${sample}_R1.fastq.gz ${sample}_R2.fastq.gz --outdir=$workdir/fastqc
done

echo 'All DONE..! Results in ' "$workdir"
