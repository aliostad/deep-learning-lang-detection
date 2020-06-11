#! /user/bin/bash

:'
this script perform a custom number of recalibration.
custom means defined by the user.

note: this script must be run after mappingV3.sh
'

sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

ddir=/media/sf_docs/data/rmdupY

counts=${ddir}/counts
realign=${ddir}/realign
call=${ddir}/callV4

reference=/media/sf_docs/data/QPX-RNA-Seq/Steve_Roberts/QPXTranscriptome_v21/QPX_transcriptome_v2orf.fasta

mkdir -p ${call}

for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}

# PHASE 1
# first call = high filters
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T HaplotypeCaller \
        -R ${reference} \
        -I ${realign}/${sample}.realign.bam \
        --genotyping_mode DISCOVERY \
        -stand_emit_conf 20 \
        -stand_call_conf 30 \
        -o ${call}/${sample}.filter.call.vcf

# recalibration
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T BaseRecalibrator \
        -R ${reference} \
        -I ${realign}/${sample}.realign.bam \
        -knownSites ${call}/${sample}.filter.call.vcf \
        -o ${call}/${sample}.recal.1.table


# apply recal
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T PrintReads \
                -R ${reference} \
                -I ${realign}/${sample}.realign.bam \
                -BQSR ${call}/${sample}.recal.1.table \
                -o ${call}/${sample}.recal.1.bam



# PHASE 2
# first call = high filters
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T HaplotypeCaller \
        -R ${reference} \
        -I ${call}/${sample}.recal.1.bam \
        --genotyping_mode DISCOVERY \
        -stand_emit_conf 30 \
        -stand_call_conf 45 \
        -o ${call}/${sample}.filter.2.call.vcf

# recalibration
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T BaseRecalibrator \
        -R ${reference} \
        -I ${call}/${sample}.recal.1.bam \
        -knownSites ${call}/${sample}.filter.2.call.vcf \
        -o ${call}/${sample}.recal.2.table


# apply recal
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T PrintReads \
                -R ${reference} \
                -I ${call}/${sample}.recal.1.bam \
                -BQSR ${call}/${sample}.recal.2.table \
                -o ${call}/${sample}.recal.2.bam



# END
# plots
# recal
    java -jar /home/neo/data/GenomeAnalysisTK.jar \
        -T BaseRecalibrator \
        -R ${reference}
        -I ${call}/${sample}.recal.2.bam \
        -knownSites ${call}/${sample}.filter.2.call.vcf \
        -BQSR ${call}/${sample}.recal.2.table \
        -o ${call}/${sample}.postrecal.table

# make sure to install R packages and dependencies
# reshape gplots ggplot2 gsalib
        java -jar /home/neo/data/GenomeAnalysisTK.jar \
            -T AnalyzeCovariates \
            -R ${reference}
            -before ${call}/${sample}.recal.1.table \
            -after ${call}/${sample}.postrecal.table \
            -plots ${call}/${sample}.recal.plots.2.pdf

#final calling
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T HaplotypeCaller \
                -R ${reference} \
                -I ${call}/${sample}.recal.2.bam \
                --genotyping_mode DISCOVERY \
                -stand_emit_conf 40 \
                -stand_call_conf 50 \
                -o ${call}/${sample}.last.call.2.vcf


done


# print number of snps
for j in 1 2 3 4 5 6
do
    sample=${sample[${j}]}
    grep "QPX_transcriptome" ${call}/${sample}.last.call.2.vcf | wc -l

done
