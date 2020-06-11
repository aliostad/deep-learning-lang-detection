#!/bin/bash
# bash sample_split.sh <sample_filename w/out .vcf.gz> <output_filename_prefix>
# Example: Suppose we have 07_UKRE.vcf.gz file we want to split up
#          bash sample_split.sh 07_UKRE 08_UKRE

sample=$1
samplefile="${sample}.vcf.gz"

gunzip -c ${samplefile} |grep -e '^#' >sample_header.vcf

for chr in $(seq 1 22); do
  echo "chr${chr}"
  out="$2.chr${chr}"
  gunzip -c ${samplefile} |grep -e ^${chr}\\s >${out}.vcf
  cat sample_header.vcf ${out}.vcf |bgzip >${out}.vcf.gz
  rm ${out}.vcf
done
echo "chrX"
out="$2.chrX"
gunzip -c ${samplefile} |grep -e ^X\\s >${out}.vcf
cat sample_header.vcf ${out}.vcf |bgzip >${out}.vcf.gz
rm ${out}.vcf

