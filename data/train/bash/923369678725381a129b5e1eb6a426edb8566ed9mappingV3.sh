#! /user/bin/bash

:'
this script accomplish 5 things:
1. map all paired end samples to reference woth bwa
2. sort the mapped contigs with samtools
3. remove duplicate contigs with picard
4. index contigs with samtools
5. count contigs with htseq
-M: bwa mark shorter hits as secondary, increase picard comaptibility
'

sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

ir=/media/sf_docs/data/QPX-RNA-Seq/trimmed
dir=/media/sf_docs/data/mappingY
ddir=/media/sf_docs/data/rmdupY

counts=${ddir}/counts
realign=${ddir}/realign
call=${ddir}/call

extension=.trimmed.P.NY.fastq.gz
reference=/media/sf_docs/data/QPX-RNA-Seq/Steve_Roberts/QPXTranscriptome_v21/QPX_transcriptome_v2orf.fasta


java -jar /home/neo/data/picard/picard.jar \
CreateSequenceDictionary \
R=${reference} \
O=/media/sf_docs/data/QPX-RNA-Seq/Steve_Roberts/QPXTranscriptome_v21/QPX_transcriptome_v2orf.dict

samtools faidx ${reference}
mkdir -p ${counts} ${realign} ${call}




for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}

    java -jar /home/neo/data/picard/picard.jar \
        SortSam \
        INPUT=${dir}/${sample}.sam \
        OUTPUT=${ddir}/${sample}.sorted.bam \
        SORT_ORDER=coordinate

    java -jar /home/neo/data/picard/picard.jar \
        MarkDuplicates \
        INPUT=${ddir}/${sample}.sorted.bam \
        OUTPUT=${ddir}/${sample}.nodup.bam \
        METRICS_FILE=${ddir}/${sample}.dup.metrics \
        REMOVE_DUPLICATES=true \
        ASSUME_SORTED=true

    java -jar /home/neo/data/picard/picard.jar \
        BuildBamIndex \
        INPUT=${ddir}/${sample}.nodup.bam

    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T CountReads \
        -R ${reference} \
        -fixMisencodedQuals \
        -I ${ddir}/${sample}.nodup.bam \
        > ${counts}/${sample}.nodup.count.txt

    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T CountReads \
        -R ${reference} \
        -fixMisencodedQuals \
        -I ${ddir}/${sample}.nodup.bam \
        -rf DuplicateRead \
        > ${counts}/${sample}.dup.count.txt



    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T RealignerTargetCreator \
        -R ${reference} \
        -fixMisencodedQuals \
        -I ${ddir}/${sample}.nodup.bam \
        -o ${realign}/${sample}.target.intervals.list

    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T IndelRealigner \
        -R ${reference} \
        -fixMisencodedQuals \
        -I ${ddir}/${sample}.nodup.bam \
        -targetIntervals ${realign}/${sample}.target.intervals.list \
        -o ${realign}/${sample}.realign.bam



# first call = high filters
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T HaplotypeCaller \
        -R ${reference} \
        -I ${realign}/${sample}.realign.bam \
        --genotyping_mode DISCOVERY \
        -stand_emit_conf 30 \
        -stand_call_conf 45 \
        -o ${call}/${sample}.hi.first.call.vcf

# recalibration
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T BaseRecalibrator \
        -R ${reference} \
        -I ${realign}/${sample}.realign.bam \
        -knownSites ${call}/${sample}.hi.first.call.vcf \
        -o ${call}/${sample}.recal.table

# recal (2)
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T BaseRecalibrator \
        -R ${reference}
        -I ${realign}/${sample}.realign.bam \
        -knownSites ${call}/${sample}.hi.first.call.vcf \
        -BQSR ${call}/${sample}.recal.table \
        -o ${call}/${sample}.postrecal.table

# plots
# make sure to install R packages and dependencies
# reshape gplots ggplot2 gsalib
        java -jar /home/neo/data/GenomeAnalysisTK.jar \
            -T AnalyzeCovariates \
            -R ${reference}
            -before ${call}/${sample}.recal.table \
            -after ${call}/${sample}.postrecal.table \
            -plots ${call}/${sample}.recal.plots.pdf

# apply recal
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T PrintReads \
                -R ${reference} \
                -I ${realign}/${sample}.realign.bam \
                -BQSR ${call}/${sample}.recal.table \
                -o ${call}/${sample}.recal.bam


#second calling
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T HaplotypeCaller \
                -R ${reference} \
                -I ${call}/${sample}.recal.bam \
                --genotyping_mode DISCOVERY \
                -stand_emit_conf 30 \
                -stand_call_conf 50 \
                -o ${call}/${sample}.last.call.vcf


done


# print number of snps
for j in 1 2 3 4 5 6
do
    sample=${sample[${j}]}
    grep "QPX_transcriptome" ${call}/${sample}.last.call.vcf | wc -l

done
