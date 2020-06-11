#!/bin/bash --login
module load Java
module load pysam
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa

fasd2vcf()
{

    sample=$1
    input=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/$sample.fasd
    output=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/$sample.fasd.vcf
    
    echo $input
    python fasd2vcf.py $input $sample $ref > $output


}

merge_snv_indel()
{
    sample=$1
    mkdir /work/projects/melanomics/analysis/transcriptome/$sample/variants/
    snv=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/$sample.fasd.vcf
    indels=/work/projects/melanomics/analysis/transcriptome/$sample/indels/$sample.combined.merged.indels.vcf
    output=/work/projects/melanomics/analysis/transcriptome/$sample/variants/$sample.fasd.indels_from.dindel.varscan.gatk.vcf
    java -Xmx2g -jar $GATK/GenomeAnalysisTK.jar \
   -R $ref \
   -T CombineVariants \
   --variant $snv \
   --variant $indels \
   -o $output

}

for k in NHEM #patient_2 patient_4_NS patient_4_PM patient_6 pool
do
    fasd2vcf $k
done


for k in NHEM #patient_2 patient_4_NS patient_4_PM patient_6 pool
do
    merge_snv_indel $k
done