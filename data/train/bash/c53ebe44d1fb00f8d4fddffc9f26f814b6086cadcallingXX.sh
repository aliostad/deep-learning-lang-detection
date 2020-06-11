#! /usr/bin/bash

:'
samtools -u for ouputing an uncompressed bcf file
-B : no baq computing for faster jobs
-d : depth of covreage, increase it to get precise depth of coverage
-f : decalre reference
-D : control the number of variant to keep per sample based on the depth of coverage
-C : reduce effect of reads with high mismatches
--min-ac : minimum of the percentage of most frequent variants
-g : yes or no for homoz/heteroz/missing nucleotides
'

reference=/media/sf_docs/data/QPX-RNA-Seq/Steve_Roberts/QPXTranscriptome_v21/QPX_transcriptome_v2orf.fasta

dir=/media/sf_docs/data/rmdupX
ddir=/media/sf_docs/data/callingXX

sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}
    samtools mpileup -u -C50 -BQ0 -d1000 -f ${reference} \
        ${dir}/${sample}.nodup.bam | \
    bcftools view --min-ac 0 -g "^miss" | \
    /home/neo/data/bcftools-1.2/vcfutils.pl varFilter -D100 \
        > ${ddir}/${sample}.var.vcf

done
# install vcf tools

