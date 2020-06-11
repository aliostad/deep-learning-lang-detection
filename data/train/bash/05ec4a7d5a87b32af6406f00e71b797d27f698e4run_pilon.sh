#!/usr/bin/sh

# Script for running Pilon on the results of an assembly.
# For this purpose, first the reads are alligned to the assembled
# genome using Burrows-Wheeler Aligner and then Pilon is run on
# the genome using the bam files output by BWA.


if [ "$#" -ne 1 ]; then
  echo "Usage: $0 ASSEMBLER" >&2
  exit 1
fi

data_dir=/data/home/jrowell32/data
assembly_dir=$data_dir/assembly/$1
pilon_dir=$data_dir/assembly/pilon/$1
pilon="java -Xmx8G -jar $HOME/pilon-1.21.jar"
trim_option=option1

for sample in $(cd $assembly_dir; ls -d OB*)
do
  echo Running for $sample
  bwa index $assembly_dir/$sample/scaffolds.fasta
  bwa mem -R '@RG\tID:foo\tSM:bar\tLB:library1' $assembly_dir/$sample/scaffolds.fasta $data_dir/trimmed/$trim_option/${sample}_R1_val_1.fq $data_dir/trimmed/$trim_option/${sample}_R2_val_2.fq > $pilon_dir/$sample.sam
  samtools view -Sb $pilon_dir/$sample.sam > $pilon_dir/$sample.bam
  rm $pilon_dir/$sample.sam
  samtools sort -o $pilon_dir/${sample}_sorted.bam $pilon_dir/${sample}.bam
  mv $pilon_dir/${sample}_sorted.bam $pilon_dir/${sample}.bam
  samtools index $pilon_dir/${sample}.bam 
  $pilon --genome $assembly_dir/$sample/scaffolds.fasta --frags $pilon_dir/${sample}.bam --output $sample --outdir $pilon_dir >> $pilon_dir/pilon.log 2>&1
  echo
done
