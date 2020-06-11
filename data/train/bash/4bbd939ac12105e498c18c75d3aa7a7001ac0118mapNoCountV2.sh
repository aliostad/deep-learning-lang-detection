#! /user/bin/bash


sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

ir=/media/sf_docs/data/QPX-RNA-Seq/trimmed
dir=/media/sf_docs/data/mappingX
ddir=/media/sf_docs/data/rmdupX
dddir=/media/sf_docs/data/callingX


extension=.trimmed.P.NY.fastq.gz
reference=/media/sf_docs/data/QPX-RNA-Seq/Steve_Roberts/QPXTranscriptome_v21/QPX_transcriptome_v2orf.fasta
count=/media/sf_docs/data/QPX-RNA-Seq/Steve_Roberts/QPXTranscriptome_v21/QPX_transcriptome_v2orf.gff3

for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}

    java -jar /home/neo/data/picard/picard.jar \
        MarkDuplicates \
        INPUT=${dir}/${sample}.sorted.bam \
        OUTPUT=${ddir}/${sample}.nodup.bam \
        METRICS_FILE=${ddir}/${sample}.dup.metrics \
        REMOVE_DUPLICATES=true \
        ASSUME_SORTED=true

    samtools index ${ddir}/${sample}.nodup.bam

    samtools mpileup -u -C50 -BQ0 -d500 -f ${reference} \
        ${ddir}/${sample}.nodup.bam | \
    bcftools view --min-ac 0 -g "^miss" | \
    /home/neo/data/bcftools-1.2/vcfutils.pl varFilter -D100 \
        > ${dddir}/${sample}.var.vcf

done


sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

ir=/media/sf_docs/data/QPX-RNA-Seq/trimmed
dir=/media/sf_docs/data/mappingX2
ddir=/media/sf_docs/data/rmdupX2
extension=.trimmed.P.NY.fastq.gz

reference=/media/sf_docs/data/mmetsp0098/contigs.fa
count=/media/sf_docs/data/mmetsp0098/MMETSP0098.gff3

for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}

    java -jar /home/neo/data/picard/picard.jar \
        MarkDuplicates \
        INPUT=${dir}/${sample}.sorted.bam \
        OUTPUT=${ddir}/${sample}.nodup.bam \
        METRICS_FILE=${ddir}/${sample}.dup.metrics \
        REMOVE_DUPLICATES=true \
        ASSUME_SORTED=true

    samtools index ${ddir}/${sample}.nodup.bam

    samtools mpileup -u -C50 -BQ0 -d500 -f ${reference} \
        ${ddir}/${sample}.nodup.bam | \
    bcftools view --min-ac 0 -g "^miss" | \
    /home/neo/data/bcftools-1.2/vcfutils.pl varFilter -D100 \
        > ${dddir}/${sample}.var.vcf

done



sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

ir=/media/sf_docs/data/QPX-RNA-Seq/trimmed
dir=/media/sf_docs/data/mappingX3
ddir=/media/sf_docs/data/rmdupX3
extension=.trimmed.P.NY.fastq.gz

reference=/media/sf_docs/data/genomeSRv015/QPX_v015.fasta
count=/media/sf_docs/data/genomeSRv015/QPX_v015.gff3

for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}

    java -jar /home/neo/data/picard/picard.jar \
        MarkDuplicates \
        INPUT=${dir}/${sample}.sorted.bam \
        OUTPUT=${ddir}/${sample}.nodup.bam \
        METRICS_FILE=${ddir}/${sample}.dup.metrics \
        REMOVE_DUPLICATES=true \
        ASSUME_SORTED=true

    samtools index ${ddir}/${sample}.nodup.bam

    samtools mpileup -u -C50 -BQ0 -d500 -f ${reference} \
        ${ddir}/${sample}.nodup.bam | \
    bcftools view --min-ac 0 -g "^miss" | \
    /home/neo/data/bcftools-1.2/vcfutils.pl varFilter -D100 \
        > ${dddir}/${sample}.var.vcf

done
