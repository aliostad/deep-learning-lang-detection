#!/bin/bash
#author Tobias Hofmann (tobiashofmann@gmx.net)
sample=$(basename "$1");
reference2=$(echo "$2" | sed 's/.fasta//');
reference=$(echo "$reference2" | sed 's/.fst//');
refbase=$(basename "$reference");
mkdir ../$sample-results;
mkdir ../$sample-results/$refbase;
echo "starting mapping of $sample to $refbase";
clc_mapper -o ../$sample-results/$refbase/$sample-$refbase-assembly.cas -d $2 -q $1/*READ1.fastq $1/*READ2.fastq -p fb ss 300 1000 --cpus 12;
echo "cas to bam convertion";
clc_cas_to_sam -a ../$sample-results/$refbase/$sample-$refbase-assembly.cas -o ../$sample-results/$refbase/$sample-$refbase.bam -f 33 -u;
echo "sorting";
samtools sort ../$sample-results/$refbase/$sample-$refbase.bam ../$sample-results/$refbase/$sample-$refbase.sorted;
echo "creating index file";
samtools index ../$sample-results/$refbase/$sample-$refbase.sorted.bam;
echo "remove old bam";
rm ../$sample-results/$refbase/$sample-$refbase.bam;
echo "**********$sample successfully mapped**********";
echo "====================================================";
echo "Starting phasing of $refbase for $sample";
echo "phasing bam files";
#creates two phased bam files called allele.0.bam and allele.1.bam
samtools phase -A -F -Q 20 -b ../$sample-results/$refbase/$sample-$refbase.allele ../$sample-results/$refbase/$sample-$refbase.sorted.bam;
echo "sorting phased bam files";
samtools sort ../$sample-results/$refbase/$sample-$refbase.allele.0.bam ../$sample-results/$refbase/$sample-$refbase.allele.0.sorted;
samtools sort ../$sample-results/$refbase/$sample-$refbase.allele.1.bam ../$sample-results/$refbase/$sample-$refbase.allele.1.sorted;
echo "mpileup and creating fq files";
samtools mpileup -u -f $2 ../$sample-results/$refbase/$sample-$refbase.allele.0.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > ../$sample-results/$refbase/$sample-$refbase.allele.0.fq;
echo "...";
samtools mpileup -u -f $2 ../$sample-results/$refbase/$sample-$refbase.allele.1.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > ../$sample-results/$refbase/$sample-$refbase.allele.1.fq;
echo "...";
samtools mpileup -u -f $2 ../$sample-results/$refbase/$sample-$refbase.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > ../$sample-results/$refbase/$sample-$refbase.original.fq;

echo "transforming fq into fasta";
sed -e '/+/,$d' ../$sample-results/$refbase/$sample-$refbase.original.fq > ../$sample-results/$refbase/$sample-$refbase.original.fasta;
sed -e '/+/,$d' ../$sample-results/$refbase/$sample-$refbase.allele.1.fq > ../$sample-results/$refbase/$sample-$refbase.allele.1.fasta;
sed -e '/+/,$d' ../$sample-results/$refbase/$sample-$refbase.allele.0.fq > ../$sample-results/$refbase/$sample-$refbase.allele.0.fasta;

perl -p -i -e 's/@/>/g' ../$sample-results/$refbase/$sample-$refbase.original.fasta;
perl -p -i -e 's/@/>/g' ../$sample-results/$refbase/$sample-$refbase.allele.1.fasta;
perl -p -i -e 's/@/>/g' ../$sample-results/$refbase/$sample-$refbase.allele.0.fasta;

rm $2.fai;

echo "**********completed $refbase for $sample**********";
