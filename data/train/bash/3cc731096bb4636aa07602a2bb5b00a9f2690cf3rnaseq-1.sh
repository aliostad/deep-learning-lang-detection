cd   /netshare1/home1/people/hansun/Data/Lundberg/RNAseq
sample=SRR040290
bowtie -p 8 --sam -C  /netshare1/home1/people/hansun/Data/GenomeSeq/Human/bowtie/hg19.c  $sample.fastq -S $sample.sam 
samtools view -bS -o $sample.bam $sample.sam
samtools  sort $sample.bam $sample.sorted
mv $sample.sorted.bam $sample.bam
samtools index $sample.bam
samtools  flagstat $sample.bam >$sample.stat



samtools mpileup -uDf /netshare1/home1/people/hansun/GATK/bundle/ucsc.hg19.fasta  $ICC4A $ICC5A $ICC9A $ICC10A $CHC5A $CHC6A $CHC7A $CHC10A  $ICC4B $ICC5B $ICC9B $ICC10B $CHC5B $CHC6B $CHC7B $CHC10B > tmp.raw.${chr}.bcf
bcftools view -bvcg tmp.raw.${chr}.bcf > var.raw.${chr}.bcf
bcftools view var.raw.${chr}.bcf | vcfutils.pl varFilter > var.flt.${chr}.vcf 


