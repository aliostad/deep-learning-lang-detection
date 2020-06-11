#! /user/bin/bash


sample[1]=mmetsp0098
sample[2]=mmetsp001433
sample[3]=mmetsp00992
sample[4]=mmetsp001002
sample[5]=mmetsp0099
sample[6]=mmetsp00100

ddir=/media/sf_docs/data/rmdupY3

counts=${ddir}/counts
realign=${ddir}/realign
call=${ddir}/callV4
hard=${ddir}/hard2

reference=/media/sf_docs/data/genomeSRv015/QPX_v015.fasta

mkdir ${hard}

for i in 1 2 3 4 5 6
do
    sample=${sample[${i}]}

# call SNPs
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T SelectVariants \
                -R ${reference} \
                -V ${call}/${sample}.last.call.2.vcf \
                -selectType SNP \
                -o ${hard}/${sample}.raw.snps.vcf


            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T VariantFiltration \
                -R ${reference} \
                -V ${hard}/${sample}.raw.snps.vcf \
                --filterExpression "QD < 10.0 || FS > 60.0 || MQ < 40.0" \
                --filterName "DISCARD" \
                -o ${hard}/${sample}.filtered.snps.vcf

# call indels
            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T SelectVariants \
                -R ${reference} \
                -V ${call}/${sample}.last.call.2.vcf \
                -selectType INDEL \
                -o ${hard}/${sample}.raw.indel.vcf

            java -jar /home/neo/data/GenomeAnalysisTK.jar \
                -T VariantFiltration \
                -R ${reference} \
                -V ${hard}/${sample}.raw.indel.vcf \
                --filterExpression "QD < 10.0 || FS > 200.0" \
                --filterName "DISCARD" \
                -o ${hard}/${sample}.filtered.indel.vcf


done


    echo "These are SNPS that passed hard filtering\n"
for j in 1 2 3 4 5 6
do
    sample=${sample[${j}]}
    grep "PASS" ${hard}/${sample}.filtered.snps.vcf | wc -l

done


    echo "These are INDELS that passed hard filtering\n"
for k in 1 2 3 4 5 6
do
    sample=${sample[${k}]}
    grep "PASS" ${hard}/${sample}.filtered.indel.vcf | wc -l

done
