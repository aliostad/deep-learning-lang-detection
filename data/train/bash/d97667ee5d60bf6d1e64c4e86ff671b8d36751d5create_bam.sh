## align the reads (not trimmed of TE to ref to find spanners)
## to the reference
## steps used to generate the included BAM file

cd data

#create bwa index file
bwa index -a bwtsw MSUr7.sample.fa 

#Align Pair 1 fastq
bwa aln MSUr7.sample.fa fq/sample_p1.fq > sample_p1.sai

#align Pair 2 fastq
bwa aln MSUr7.sample.fa fq/sample_p2.fq > sample_p2.sai

#generate SAM for paired reads
bwa sampe MSUr7.sample.fa sample_p1.sai sample_p2.sai fq/sample_p1.fq fq/sample_p2.fq > sample.paired.sam

#align unparied
bwa aln MSUr7.sample.fa fq/sample.unPaired.fq > sample.unPaired.sai

#generate SAM for unpaired reads
bwa samse MSUr7.sample.fa  sample.unPaired.sai fq/sample.unPaired.fq > sample.unPaired.sam

#generate BAM with SAMtools
samtools view -h -b -S -T MSUr7.sample.fa sample.paired.sam > sample.paired.bam
samtools view -h -b -S -T MSUr7.sample.fa sample.unPaired.sam > sample.unPaired.bam

#combine BAM
samtools cat -o sample.bam sample.unPaired.bam sample.paired.bam 

#sort BAM with SAMtools
samtools sort sample.bam sample.sorted

#index BAM with SAMtools
samtools index sample.sorted.bam

#clean up
rm -f sample.bam sample.bam sample.unPaired.bam sample.paired.bam sample.unPaired.sam  sample.paired.sam sample.unPaired.sai sample_p2.sai sample_p1.sai

cd ..
